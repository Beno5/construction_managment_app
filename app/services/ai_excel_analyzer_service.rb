# app/services/ai_excel_analyzer_service.rb
require "roo"
require "json"

class AiExcelAnalyzerService
  CHUNK_SIZE = 400 # koliko redova po chunku šaljemo GPT-u

  def initialize(file_path, original_filename)
    @file_path = Pathname.new(file_path).to_s
    @filename = File.basename(original_filename, File.extname(original_filename)).titleize
    @project_fallback_name = default_fallback_name
    @client = OpenAI_CLIENT || OpenAI::Client.new(api_key: ENV.fetch("OPENAI_API_KEY", nil))
  end

  def analyze
    ext = File.extname(@file_path).downcase

    flat_chunks =
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

    all_results = []

    flat_chunks.each_with_index do |chunk_text, i|
      prompt = build_prompt(chunk_text, chunk_number: i + 1, total_chunks: flat_chunks.size)

      response = @client.chat.completions.create(
        model: ENV.fetch("OPENAI_MODEL", "gpt-4.1"),
        temperature: 0.2,
        messages: [
          { role: "system", content: "You are an AI that analyzes messy construction documents (Excel, Word or PDF)." },
          { role: "user", content: prompt }
        ]
      )

      raw = response.choices.first.message[:content]
      json = parse_json_safe(raw)
      all_results << json
    end

    merge_results(all_results)
  end

  private

  # fallback ime projekta
  def default_fallback_name
    count = Project.count + 1
    "Imported Project #{count}"
  end

  # Parsiraj JSON sa fallback-om ako je djelimično oštećen
  def parse_json_safe(raw)
    JSON.parse(raw)
  rescue JSON::ParserError
    json_str = raw.match(/\{.*\}/m)&.to_s
    json_str ? JSON.parse(json_str) : { "error" => "Invalid JSON", "raw" => raw }
  end

  # Podijeli Excel na chunkove po 200 redova
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

          rows << "#{i + 1}\t" << values[0, 20].join("\t") << "\n"

          if (i + 1) % CHUNK_SIZE == 0
            chunks << ("=== SHEET: #{sheet_name} (Part #{chunks.size + 1}) ===\n" + rows.join)
            rows = []
          end
        end
      else
        # For .xls and .ods files - regular iteration
        sheet.each_with_index do |row, i|
          values = row.map { |c| normalize_cell_value(c) }
          next if values.all?(&:blank?)

          rows << "#{i + 1}\t" << values[0, 20].join("\t") << "\n"

          if (i + 1) % CHUNK_SIZE == 0
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

    # Izvuci sve paragrafe u običan tekst
    paragraphs = doc.paragraphs.map(&:text).reject(&:blank?)
    chunks = []
    buffer = []

    paragraphs.each_with_index do |line, i|
      buffer << line.strip

      if (i + 1) % CHUNK_SIZE == 0
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
    text.scan(/.{1,10000}/m) # chunk po 10k karaktera
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
      - Naslovi velikim slovima (npr. “HIDRANTSKA MREŽA”, “ZIDARSKI RADOVI”, “VODOINSTALACIJE”) su TASK.
      - Redovi koji počinju brojem (npr. “1.”, “2.01”) su SUB_TASK.
      - Sve ispod subtaska (materijali, spratovi, količine...) ide u njegov `description`.
      - Prepoznaj `unit_of_measure` iz oznaka (“m”, “m2”, “m3”, “kom”, “kg”, “set”…).
      - `quantity` = broj uz jedinicu (npr. “41 m3”, “1,00 kom”).
      - Ako vidiš “cena”, “ukupno”, “€” → koristi za `unit_price` i `total_cost`.
      - Ako postoji “HITNO”, “ROK”, “NAPOMENA” → stavi u `custom_fields`.
      - **OBAVEZNO: Svaki `name` i `description` mora počinjati velikim slovom. Npr: "geodetska merenja" → "Geodetska merenja"**


      ⚙️ **Uputstva:**
      - Ignoriši nazive kolona (“Opis radova”, “JM”, “Količina”, “Cena”).
      - Ne izmišljaj vrednosti — ako ne postoji, koristi `null`.
      - Vrati isključivo čist JSON bez objašnjenja ili komentara.

      📄 **Input (deo #{chunk_number}/#{total_chunks} iz fajla "#{@filename}", koji može sadržati više sheetova):**
      #{flat_text}
    PROMPT
  end

  # Spajanje svih JSON chunkova u jedan validan projekat
  def merge_results(results)
    valid = results.reject { |r| r["error"] }
    base = valid.first || { "project" => { "name" => @project_fallback_name, "tasks" => [] } }

    valid.drop(1).each do |res|
      res_tasks = res.dig("project", "tasks") || []
      base["project"]["tasks"].concat(res_tasks)
    end

    base
  end
end
