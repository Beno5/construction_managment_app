# app/services/ai_excel_analyzer_service.rb
require "roo"
require "json"
require "timeout"
require "concurrent"

# AI Excel Analyzer with concurrent processing, retry mechanism, and progress tracking
# Optimized for speed and reliability with the following features:
# - Concurrent chunk processing using Thread pool
# - Retry mechanism with exponential backoff
# - Timeout protection per chunk and total job
# - Chunk caching using Redis
# - Real-time progress tracking
# - Configurable chunk size for performance tuning
class AiExcelAnalyzerService
  # Configuration constants
  DEFAULT_CHUNK_SIZE = 400 # rows per chunk sent to GPT (adjustable: 200, 300, 400, 500)
  MAX_RETRIES = 3 # retry failed chunks up to 3 times
  CHUNK_TIMEOUT = 120 # 2 minutes timeout per chunk
  TOTAL_JOB_TIMEOUT = 900 # 15 minutes total job timeout
  MAX_CHUNKS = 50 # prevent infinite loops - max 50 chunks per job
  CONCURRENT_WORKERS = 1 # parallel workers for chunk processing (optimized for Heroku Basic - 1 dyno)
  TEMPERATURE = 0.1 # lower temperature for faster, more deterministic responses

  attr_reader :metrics

  def initialize(file_path, original_filename, chunk_size: DEFAULT_CHUNK_SIZE)
    @file_path = Pathname.new(file_path).to_s
    @filename = File.basename(original_filename, File.extname(original_filename)).titleize
    @project_fallback_name = default_fallback_name
    @client = OpenAI_CLIENT || OpenAI::Client.new(api_key: ENV.fetch("OPENAI_API_KEY", nil))
    @chunk_size = chunk_size

    # Thread-safe metrics using Concurrent::AtomicFixnum
    @metrics = {
      total_time: 0,
      chunks_processed: Concurrent::AtomicFixnum.new(0),
      chunks_failed: Concurrent::AtomicFixnum.new(0),
      retries: Concurrent::AtomicFixnum.new(0),
      cache_hits: Concurrent::AtomicFixnum.new(0)
    }
    @metrics_lock = Mutex.new
  end

  def analyze
    start_time = Time.current

    # Step 1: Extract file extension and prepare chunks
    ext = File.extname(@file_path).downcase
    Rails.logger.info "📄 [AIAnalyzer] Processing #{ext} file: #{@filename}"

    # Step 2: Flatten document into chunks
    flat_chunks = extract_chunks_from_file(ext)

    # Step 3: Validate chunk count
    if flat_chunks.size > MAX_CHUNKS
      error_msg = "Document too large: #{flat_chunks.size} chunks (max #{MAX_CHUNKS}). Please split the file."
      Rails.logger.error "❌ [AIAnalyzer] #{error_msg}"
      raise StandardError, error_msg
    end

    Rails.logger.info "📊 [AIAnalyzer] Extracted #{flat_chunks.size} chunks (#{@chunk_size} rows each)"

    # Step 4: Process chunks with timeout protection
    all_results = Timeout.timeout(TOTAL_JOB_TIMEOUT) do
      process_chunks_concurrently(flat_chunks)
    end

    # Step 5: Merge results
    merged_result = merge_results(all_results)

    # Step 6: Calculate metrics
    @metrics[:total_time] = (Time.current - start_time).round(2)
    log_metrics

    merged_result
  rescue Timeout::Error
    Rails.logger.error "⏱️ [AIAnalyzer] Job timeout after #{TOTAL_JOB_TIMEOUT} seconds"
    raise StandardError, "AI import timeout - please try with a smaller file"
  rescue StandardError => e
    Rails.logger.error "💥 [AIAnalyzer] Error: #{e.message}"
    raise
  end

  private

  # Fallback project name
  def default_fallback_name
    count = Project.count + 1
    "Imported Project #{count}"
  end

  # Extract chunks from file based on type
  def extract_chunks_from_file(ext)
    case ext
    when ".xlsx", ".xls", ".ods"
      flatten_excel_in_chunks(@file_path)
    when ".docx", ".doc"
      flatten_word_in_chunks(@file_path)
    when ".pdf"
      flatten_pdf_in_chunks(@file_path)
    else
      raise "Unsupported file format: #{ext}"
    end
  end

  # Process chunks concurrently using thread pool
  def process_chunks_concurrently(chunks)
    results = Array.new(chunks.size)
    thread_pool = Concurrent::FixedThreadPool.new(CONCURRENT_WORKERS)
    promises = []

    chunks.each_with_index do |chunk_text, i|
      promise = Concurrent::Promise.execute(executor: thread_pool) do
        process_single_chunk(chunk_text, chunk_number: i + 1, total_chunks: chunks.size)
      end

      promise.then do |result|
        results[i] = result
      end

      promise.rescue do |error|
        Rails.logger.error "❌ [AIAnalyzer] Chunk #{i + 1} failed: #{error.message}"
        results[i] = { "error" => error.message, "chunk_number" => i + 1 }
      end

      promises << promise
    end

    # Wait for all promises to complete
    promises.each(&:wait)
    thread_pool.shutdown
    thread_pool.wait_for_termination

    Rails.logger.info "✅ [AIAnalyzer] All #{chunks.size} chunks processed"
    results.compact
  end

  # Process a single chunk with retry mechanism and caching
  def process_single_chunk(chunk_text, chunk_number:, total_chunks:)
    chunk_start_time = Time.current

    # Check cache first
    cache_key = chunk_cache_key(chunk_text, chunk_number)
    cached_result = Rails.cache.read(cache_key)

    if cached_result
      @metrics[:cache_hits].increment
      Rails.logger.info "💾 [AIAnalyzer] Cache hit for chunk #{chunk_number}"
      return cached_result
    end

    # Process with retry mechanism
    result = retry_with_backoff(chunk_number) do
      Timeout.timeout(CHUNK_TIMEOUT) do
        send_chunk_to_openai(chunk_text, chunk_number: chunk_number, total_chunks: total_chunks)
      end
    end

    # Cache successful result
    Rails.cache.write(cache_key, result, expires_in: 24.hours)

    # Track timing
    chunk_duration = (Time.current - chunk_start_time).round(2)
    @metrics[:chunks_processed].increment

    Rails.logger.info "✅ [AIAnalyzer] Chunk #{chunk_number}/#{total_chunks} completed in #{chunk_duration}s"
    result
  rescue Timeout::Error
    @metrics[:chunks_failed].increment
    error_msg = "Chunk timeout after #{CHUNK_TIMEOUT} seconds"
    Rails.logger.error "⏱️ [AIAnalyzer] #{error_msg}"
    { "error" => error_msg, "chunk_number" => chunk_number }
  rescue StandardError => e
    @metrics[:chunks_failed].increment
    Rails.logger.error "❌ [AIAnalyzer] Chunk #{chunk_number} failed: #{e.message}"
    { "error" => e.message, "chunk_number" => chunk_number }
  end

  # Retry mechanism with exponential backoff
  # Retries only network-related errors (timeouts, connection errors)
  def retry_with_backoff(chunk_number, max_retries: MAX_RETRIES)
    attempt = 0

    begin
      attempt += 1
      yield
    rescue Net::ReadTimeout, Net::OpenTimeout, Errno::ECONNREFUSED, SocketError, Errno::ETIMEDOUT => e
      # Network errors - retry with backoff
      if attempt < max_retries
        wait_time = 2**attempt # exponential backoff: 2s, 4s, 8s
        @metrics[:retries].increment
        Rails.logger.warn "⚠️ [AIAnalyzer] Chunk #{chunk_number} retry #{attempt}/#{max_retries} after #{wait_time}s (#{e.class})"
        sleep(wait_time)
        retry
      else
        Rails.logger.error "❌ [AIAnalyzer] Chunk #{chunk_number} failed after #{max_retries} retries"
        raise
      end
    rescue StandardError => e
      # OpenAI API errors, JSON errors, etc - don't retry, just log and raise
      Rails.logger.error "❌ [AIAnalyzer] Chunk #{chunk_number} non-retryable error: #{e.class} - #{e.message}"
      raise
    end
  end

  # Send chunk to OpenAI API
  def send_chunk_to_openai(chunk_text, chunk_number:, total_chunks:)
    prompt = build_prompt(chunk_text, chunk_number: chunk_number, total_chunks: total_chunks)

    response = @client.chat.completions.create(
      model: ENV.fetch("OPENAI_MODEL", "gpt-4.1"),
      temperature: TEMPERATURE,
      messages: [
        { role: "system", content: "You are an AI that analyzes messy construction documents (Excel, Word or PDF)." },
        { role: "user", content: prompt }
      ]
    )

    raw = response.choices.first.message[:content]
    parse_json_safe(raw)
  end

  # Generate cache key for chunk
  def chunk_cache_key(chunk_text, chunk_number)
    content_hash = Digest::MD5.hexdigest(chunk_text)
    "ai_import_chunk_#{@filename}_#{chunk_number}_#{content_hash}"
  end

  # Parse JSON with fallback
  def parse_json_safe(raw)
    JSON.parse(raw)
  rescue JSON::ParserError
    json_str = raw.match(/\{.*\}/m)&.to_s
    json_str ? JSON.parse(json_str) : { "error" => "Invalid JSON", "raw" => raw }
  end

  # Split Excel into chunks
  def flatten_excel_in_chunks(path)
    xls = Roo::Spreadsheet.open(path)
    chunks = []

    xls.sheets.each do |sheet_name|
      sheet = xls.sheet(sheet_name)
      rows = []

      # Use streaming for .xlsx (memory efficient), regular iteration for .xls and .ods
      if sheet.respond_to?(:each_row_streaming)
        # For .xlsx files - streaming approach
        sheet.each_row_streaming(pad_cells: true).each_with_index do |row, i|
          values = row.map { |c| normalize_cell_value(c&.value) }
          next if values.all?(&:blank?)

          rows << "#{i + 1}\t#{values[0, 20].join("\t")}\n"

          if (i + 1) % @chunk_size == 0
            chunks << ("=== SHEET: #{sheet_name} (Part #{chunks.size + 1}) ===\n" + rows.join)
            rows = []
          end
        end
      else
        # For .xls and .ods files - regular iteration
        sheet.each_with_index do |row, i|
          values = row.map { |c| normalize_cell_value(c) }
          next if values.all?(&:blank?)

          rows << "#{i + 1}\t#{values[0, 20].join("\t")}\n"

          if (i + 1) % @chunk_size == 0
            chunks << ("=== SHEET: #{sheet_name} (Part #{chunks.size + 1}) ===\n" + rows.join)
            rows = []
          end
        end
      end

      chunks << ("=== SHEET: #{sheet_name} (Part #{chunks.size + 1}) ===\n" + rows.join) unless rows.empty?
    end

    chunks
  end

  def flatten_word_in_chunks(path)
    require "docx"
    doc = Docx::Document.open(path)

    # Extract all paragraphs as plain text
    paragraphs = doc.paragraphs.map(&:text).reject(&:blank?)
    chunks = []
    buffer = []

    paragraphs.each_with_index do |line, i|
      buffer << line.strip

      if (i + 1) % @chunk_size == 0
        chunks << buffer.join("\n")
        buffer = []
      end
    end

    chunks << buffer.join("\n") unless buffer.empty?
    chunks
  end

  def flatten_pdf_in_chunks(path)
    require "pdf/reader"
    reader = PDF::Reader.new(path)
    text = reader.pages.map(&:text).join("\n")
    text.scan(/.{1,10000}/m) # chunk by 10k characters
  end

  def normalize_cell_value(value)
    case value
    when Date then value.strftime("%Y-%m-%d")
    when BigDecimal, Float then value.to_f.round(2)
    else
      value.to_s.strip.gsub(/\s+/, " ")
    end
  end

  def build_prompt(flat_text, chunk_number:, total_chunks:)
    <<~PROMPT
      Analiziraj neuređene Excel predmere i predračune građevinskih radova (Srbija, BiH, Hrvatska) i
      konvertuj ih u jasan JSON model sa hijerarhijom **Task → SubTask**.

      📘 **Cilj:**
      - Strukturiši sve radove, količine, materijale i troškove.
      - Ako Excel ima više sheetova, tretiraj ih kao delove istog projekta — svaki sheet je novi **task**, ali svi pripadaju istom `project` objektu.
      - Sve redove ispod subtaska koji sadrže materijal, spratove, količine, napomene i slične detalje spoji u `description` kao tekst.

      📗 **FORMAT ODGOVORA (strogo JSON):**
      {
        "project": {
          "name": "#{@filename}",
          "description": "Opis projekta ili ostale informacije koje ne znas gdje ces ako postoji, inače null",
          "address": "Adresa projekta ako postoji, inače null",
          "project_manager": "Ime projekt menadžera ako postoji, inače null",
          "planned_cost": "ukupna vrednost ako postoji (broj ili null)",
          "planned_start_date": "planirani početak ako postoji (npr. '2024-07-01') ili null",
          "planned_end_date": "planirani završetak ako postoji (npr. '2024-07-01') ili null",
          "tasks": [
            {
              "name": "Glavna grupa radova (npr. HIDRANTSKA MREŽA, ZIDARSKI RADOVI)",
              "description": "Opis ako postoji, inače null",
              "planned_cost": "ukupna vrednost ako postoji (broj ili null)",
              "planned_start_date": "planirani početak ako postoji (npr. '2024-07-01') ili null",
              "planned_end_date": "planirani završetak ako postoji (npr. '2024-07-01') ili null",
              "sub_tasks": [
                {
                  "name": "Konkretni rad (npr. Izrada priključka vodovoda)",
                  "description": "Tekstualno: svi redovi ispod tog rada — npr. materijali, spratovi, količine, napomene...",
                  "unit_of_measure": "npr. m, m2, m3, kom, kg, l, set, null ako ne postoji",
                  "quantity": "npr. 279, null ako nema",
                  "unit_price": "cena po jedinici ako postoji (broj ili null)",
                  "total_cost": "ukupna vrednost ako postoji (broj ili null)",
                  "custom_fields": {
                    "hitno": "DA/NE ili null ako ne postoji",
                    "napomena": "tekst ako postoji"
                  }
                }
              ]
            }
          ]
        }
      }

      📏 **Pravila:**
      - Naslovi velikim slovima (npr. "HIDRANTSKA MREŽA", "ZIDARSKI RADOVI", "VODOINSTALACIJE") su TASK.
      - Redovi koji počinju brojem (npr. "1.", "2.01") su SUB_TASK.
      - Sve ispod subtaska (materijali, spratovi, količine...) ide u njegov `description`.
      - Prepoznaj `unit_of_measure` iz oznaka ("m", "m2", "m3", "kom", "kg", "set"…).
      - `quantity` = broj uz jedinicu (npr. "41 m3", "1,00 kom").
      - Ako vidiš "cena", "ukupno", "€" → koristi za `unit_price` i `total_cost`.
      - Ako postoji "HITNO", "ROK", "NAPOMENA" → stavi u `custom_fields`.
      - **OBAVEZNO: Svaki `name` i `description` mora počinjati velikim slovom. Npr: "geodetska merenja" → "Geodetska merenja"**


      ⚙️ **Uputstva:**
      - Ignoriši nazive kolona ("Opis radova", "JM", "Količina", "Cena").
      - Ne izmišljaj vrednosti — ako ne postoji, koristi `null`.
      - Vrati isključivo čist JSON bez objašnjenja ili komentara.

      📄 **Input (deo #{chunk_number}/#{total_chunks} iz fajla "#{@filename}", koji može sadržati više sheetova):**
      #{flat_text}
    PROMPT
  end

  # Merge all JSON chunks into one valid project
  def merge_results(results)
    valid = results.reject { |r| r["error"] }
    failed = results.select { |r| r["error"] }

    # Log failed chunks
    if failed.any?
      Rails.logger.warn "⚠️ [AIAnalyzer] #{failed.size} chunks failed, continuing with #{valid.size} successful chunks"
      failed.each do |f|
        Rails.logger.warn "  - Chunk #{f['chunk_number']}: #{f['error']}"
      end
    end

    # Return error if all chunks failed
    if valid.empty?
      Rails.logger.error "❌ [AIAnalyzer] All chunks failed!"
      return { "project" => { "name" => @project_fallback_name, "tasks" => [], "errors" => failed } }
    end

    # Merge successful chunks
    base = valid.first || { "project" => { "name" => @project_fallback_name, "tasks" => [] } }

    valid.drop(1).each do |res|
      res_tasks = res.dig("project", "tasks") || []
      base["project"]["tasks"].concat(res_tasks)
    end

    # Add metadata about failed chunks
    if failed.any?
      base["project"]["import_warnings"] = {
        total_chunks: results.size,
        successful_chunks: valid.size,
        failed_chunks: failed.size,
        failed_chunk_numbers: failed.map { |f| f["chunk_number"] }
      }
    end

    base
  end

  # Log performance metrics
  def log_metrics
    processed = @metrics[:chunks_processed].value
    failed = @metrics[:chunks_failed].value
    retries = @metrics[:retries].value
    cache_hits = @metrics[:cache_hits].value

    Rails.logger.info "📊 [AIAnalyzer] Performance Metrics:"
    Rails.logger.info "  - Total time: #{@metrics[:total_time]}s"
    Rails.logger.info "  - Chunks processed: #{processed}"
    Rails.logger.info "  - Chunks failed: #{failed}"
    Rails.logger.info "  - Retries: #{retries}"
    Rails.logger.info "  - Cache hits: #{cache_hits}"
    return unless processed > 0

    Rails.logger.info "  - Average time per chunk: #{(@metrics[:total_time] / processed.to_f).round(2)}s"
  end
end
