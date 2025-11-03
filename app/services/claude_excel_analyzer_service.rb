# app/services/claude_excel_analyzer_service.rb
require "roo"
require "json"

class ClaudeExcelAnalyzerService
  MAX_ROWS_PER_SHEET = 1000 # ✅ Smanji sa 10k na 1k
  MAX_COLUMNS = 15          # ✅ Ograniči broj kolona
  REQUEST_TIMEOUT = 180
  
  def initialize(file_path)
    @file_path = Pathname.new(file_path).to_s
    @filename = File.basename(@file_path, File.extname(@file_path)).titleize
    @client = Anthropic::Client.new(
      access_token: ENV.fetch("ANTHROPIC_API_KEY"),
      request_timeout: REQUEST_TIMEOUT
    )
  end

  def analyze
    excel_content = extract_excel_content_optimized
    
    Rails.logger.info "📤 Šaljem #{excel_content.length} karaktera Claude-u (#{excel_content.length / 4} tokena approx)..."
    
    response = @client.messages(
      parameters: {
        model: "claude-sonnet-4-5-20250929",
        max_tokens: 16_000,
        temperature: 0.1,
        messages: [
          {
            role: "user",
            content: build_prompt(excel_content)
          }
        ]
      }
    )

    parse_response(response)
  rescue Faraday::TimeoutError => e
    Rails.logger.error "⏱️ Claude timeout nakon #{REQUEST_TIMEOUT}s"
    raise StandardError, "AI analiza traje predugo. Pokušajte sa manjim fajlom."
  rescue Faraday::ConnectionFailed, Faraday::SSLError => e
    Rails.logger.error "🌐 Connection error: #{e.message}"
    raise StandardError, "Problem sa konekcijom. Provjerite internet vezu."
  end

  private

  def extract_excel_content_optimized
    xls = Roo::Spreadsheet.open(@file_path)
    content = []
    total_rows = 0

    xls.sheets.each do |sheet_name|
      sheet = xls.sheet(sheet_name)
      
      # ✅ Preskoči prazne sheet-ove
      next if sheet.last_row.nil? || sheet.last_row == 0
      
      content << "\n" << "="*60
      content << "\nSHEET: #{sheet_name} (#{sheet.last_row} rows)"
      content << "\n" << "="*60 << "\n"
      
      sheet_rows = 0
      last_row_was_empty = false
      
      sheet.each_row_streaming(pad_cells: true).each_with_index do |row, i|
        break if sheet_rows >= MAX_ROWS_PER_SHEET
        
        # ✅ Uzmi samo prvih MAX_COLUMNS kolona
        values = row[0...MAX_COLUMNS].map { |cell| normalize_cell_value(cell&.value) }
        
        # ✅ Preskoči prazne redove ali zadrži jedan za kontekst
        if values.all?(&:blank?)
          next if last_row_was_empty
          last_row_was_empty = true
          next
        end
        
        last_row_was_empty = false
        
        # ✅ Kompresuj whitespace
        row_text = values.join("\t").gsub(/\t+/, "\t").strip
        content << "#{i + 1}\t#{row_text}\n" unless row_text.blank?
        
        sheet_rows += 1
        total_rows += 1
      end
      
      Rails.logger.info "📊 Sheet '#{sheet_name}': #{sheet_rows} redova (od #{sheet.last_row} total)"
    end

    Rails.logger.info "📋 Ukupno poslato: #{total_rows} redova iz #{xls.sheets.size} sheet(ova)"
    content.join
  end

  def normalize_cell_value(value)
    case value
    when Date, DateTime
      value.strftime("%Y-%m-%d")
    when BigDecimal, Float
      # ✅ Skrati decimale
      value.round(2).to_s.gsub(/\.0+$/, '')
    when nil
      ""
    when String
      # ✅ Trim i ukloni extra whitespace
      value.strip.gsub(/\s+/, " ")[0...200] # Max 200 chars per cell
    else
      value.to_s.strip[0...200]
    end
  end

  def build_prompt(excel_content)
    <<~PROMPT
      Analiziraj ovaj građevinski predmer/predračun: "#{@filename}"

      **KONTEKST:**
      - Balkanski građevinski dokument (može biti neuređen)
      - Različiti nazivi za iste jedinice (kom/komad/pcs, m2/m²/kvadrat)
      - Tabele mogu imati merged cells, multiple headers, ukupne sume
      - Neki redovi su naslovi, neki stavke, neki totali - koristi kontekst
      - PRIORITET: Fokusiraj se na redove sa konkretnim količinama i stavkama

      **ZADATAK:**
      1. Identifikuj TASKS (pozicije) - glavne kategorije radova (npr "Zemljani radovi", "Betonski radovi")
      2. Identifikuj SUB_TASKS (podpozicije) - konkretne stavke sa količinama
      3. Izvuci: naziv, količinu, mjernu jedinicu, cijenu (ako postoji)
      4. Grupiši logički povezane stavke pod isti TASK

      **JEDINICE MJERE (normaliziraj):**
      pieces (kom/komad/pcs), m (metar), m2 (kvadrat/m²), m3 (kub/m³), kg, ton, liters, roll, bag, set

      **JSON FORMAT (bez dodatnog teksta ili markdown):**
      {
        "project": {
          "name": "#{@filename}",
          "description": null,
          "tasks": [
            {
              "name": "Naziv pozicije",
              "description": null,
              "sub_tasks": [
                {
                  "name": "Naziv stavke",
                  "description": null,
                  "unit_of_measure": "pieces|m|m2|m3|kg|ton|null",
                  "quantity": 100.5,
                  "price_per_unit": 50.00,
                  "total_cost": 5025.00
                }
              ]
            }
          ]
        }
      }

      **PRAVILA:**
      - NE izmišljaj podatke - koristi null
      - Ignoriši prazne redove i naslove
      - Vrati SAMO JSON (bez ```json``` oznaka)
      - Ako nema dovoljno podataka za sub_task, preskoči ga

      **EXCEL:**
      #{excel_content}
    PROMPT
  end

  def parse_response(response)
    raw_text = response.dig("content", 0, "text")
    
    Rails.logger.info "🤖 Claude odgovor primljen (#{raw_text.length} chars)"
    
    # ✅ Bolje izvlačenje JSON-a
    json_str = extract_json_from_text(raw_text)
    
    result = JSON.parse(json_str)
    
    # ✅ Validacija
    unless result.dig("project", "tasks").is_a?(Array)
      raise JSON::ParserError, "Invalid structure: missing project.tasks array"
    end
    
    result
  rescue JSON::ParserError => e
    Rails.logger.error "❌ JSON parse greška: #{e.message}"
    Rails.logger.error "Raw (first 500 chars):\n#{raw_text[0...500]}"
    
    # Fallback
    {
      "project" => {
        "name" => @filename,
        "tasks" => [],
        "error" => "Greška pri parsiranju: #{e.message}"
      }
    }
  end

  def extract_json_from_text(text)
    # Pokušaj 1: Markdown code block
    if text.include?("```")
      match = text.match(/```(?:json)?\s*(\{.*?\})\s*```/m)
      return match[1] if match
    end
    
    # Pokušaj 2: Samo JSON objekat
    match = text.match(/(\{.*\})/m)
    return match[1] if match
    
    # Pokušaj 3: Cijeli text
    text
  end
end