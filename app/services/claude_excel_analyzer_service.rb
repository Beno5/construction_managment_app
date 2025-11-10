# app/services/claude_excel_analyzer_service.rb
require "roo"
require "json"

class ClaudeExcelAnalyzerService
  MAX_ROWS_PER_REQUEST = 500  # Pošalji sve odjednom ako je manje od 500
  
  def initialize(file_path)
    @file_path = Pathname.new(file_path).to_s
    @filename = File.basename(@file_path, File.extname(@file_path)).titleize
    @client = Anthropic::Client.new(
      access_token: ENV.fetch("ANTHROPIC_API_KEY"),
      request_timeout: 180
    )
  end

  def analyze
    excel_text = flatten_excel_to_text(@file_path)
    
    Rails.logger.info "📤 Šaljem #{excel_text.length} karaktera Claude-u..."
    
    response = @client.messages(
      parameters: {
        model: "claude-sonnet-4-5-20250929",
        max_tokens: 16_000,
        temperature: 0,
        messages: [
          { role: "user", content: build_simple_prompt(excel_text) }
        ]
      }
    )

    parse_response(response)
  rescue => e
    Rails.logger.error "❌ Greška: #{e.message}"
    {
      "project" => {
        "name" => @filename,
        "tasks" => [],
        "error" => e.message
      }
    }
  end

  private

  # ✅ JEDNOSTAVNO - flatten cijeli Excel u text
  def flatten_excel_to_text(path)
    xls = Roo::Spreadsheet.open(path)
    output = []
    
    # Uzmi sve sheet-ove ili prvi
    sheets = xls.sheets.select { |s| s.match?(/sheet|predmer|vodovod|kanal/i) }
    sheets = xls.sheets.first(1) if sheets.empty?
    
    sheets.each do |sheet_name|
      sheet = xls.sheet(sheet_name)
      output << "=== SHEET: #{sheet_name} ==="
      
      sheet.each_row_streaming(pad_cells: true).each_with_index do |row, idx|
        values = row.map { |cell| clean_cell(cell&.value) }
        next if values.all?(&:blank?)
        
        # Jednostavan format: kolone odvojene sa |
        output << values[0..10].join(" | ")
        
        break if idx > MAX_ROWS_PER_REQUEST
      end
    end
    
    output.join("\n")
  end

  def clean_cell(value)
    case value
    when Date, DateTime
      value.strftime("%Y-%m-%d")
    when BigDecimal, Float
      value.round(2).to_s.delete_suffix(".0")
    when nil
      ""
    when String
      value.strip.gsub(/\s+/, " ").gsub(/['']/, '"')
    else
      value.to_s.strip
    end
  end

  # ✅ KRATAK I JASAN PROMPT
  def build_simple_prompt(excel_text)
    <<~PROMPT
      Analiziraj građevinski predmer i izvuci Tasks i SubTasks.

      **PRAVILA:**
      1. TASK = glavna pozicija (npr "A. PRIPREMNI RADOVI", "1  ZEMLJANI RADOVI", "ELEKTRO INSTALACIJE")
      2. SUB_TASK = podpozicija sa količinom (npr "1.01", "1", "2.02")
      3. Vrati SAMO JSON bez markdown-a

      **TASK IDENTIFIKACIJA (bilo koji od ovih):**
      - Slova: "A.", "B.", "C."
      - Brojevi: "1", "2", "3" (ako je cijeli red pozicija)
      - VELIKA SLOVA u tekstu

      **SUB_TASK IDENTIFIKACIJA:**
      - Ima količinu I jedinicu mjere
      - Dekadni brojevi: "1.01", "1.02", "2.01"
      - Obični brojevi: "1", "2", "3" (ako ima količinu u istom redu)

      **JSON FORMAT:**
      {
        "project": {
          "name": "#{@filename}",
          "description": null,
          "tasks": [
            {
              "name": "IME pozicije (kratko, npr 'Pripremni radovi')",
              "description": "Dodatni opis ako postoji (može biti null)",
              "sub_tasks": [
                {
                  "name": "IME podpozicije (kratko, npr 'Geodetsko obeležavanje')",
                  "description": "DETALJAN OPIS stavke (kompletan tekst iz Excel-a)",
                  "unit_of_measure": "pieces|m|m2|m3|kg|ton|liters|pausal|hours|null",
                  "quantity": 10.5,
                  "price_per_unit": null,
                  "total_cost": null,
                  "custom_fields": {"code": "1.01"}
                }
              ]
            }
          ]
        }
      }

      **KRITIČNO - NAME vs DESCRIPTION:**
      - task.name = KRATKO IME pozicije (npr "Pripremni radovi")
      - task.description = dodatne informacije ako postoje (ili null)
      - subtask.name = KRATKO IME stavke (npr "Geodetsko obeležavanje")
      - subtask.description = KOMPLETAN OPIS stavke (cijeli tekst iz Excel-a)

      **JEDINICE MJERE (normalizuj ili null ako nepoznato):**
      - m1/metar → m
      - m²/kvadrat → m2
      - m³/kubik → m3
      - kom/komad/piece/pcs → pieces
      - kg/kilogram → kg
      - t/tona → ton
      - l/litar → liters
      - h/sat/sati → hours
      - pauš/paušal/paušalno → pausal
      - AKO NIJE U OVOJ LISTI → null

      **VAŽNO:**
      - Za "name" koristi KRATKO IME, ne kod (npr "Pripremni radovi", NE "A")
      - Za "description" stavi KOMPLETAN opis stavke (ili null)
      - Ignoriši redove bez količine i jedinice
      - Koristi null za nedostajuće podatke

      **EXCEL:**
      #{excel_text}
    PROMPT
  end

  def parse_response(response)
    raw_text = response.dig("content", 0, "text")
    
    Rails.logger.info "🤖 Primljen odgovor: #{raw_text.length} chars"
    
    # Strip markdown i izvuci JSON
    json_str = raw_text.strip
                       .gsub(/^```json\s*/, '')
                       .gsub(/^```\s*/, '')
                       .gsub(/\s*```$/, '')
                       .strip
    
    # Nađi JSON objekat
    if json_str[0] != '{'
      match = json_str.match(/(\{.*\})/m)
      json_str = match[1] if match
    end
    
    result = JSON.parse(json_str)
    
    tasks_count = result.dig("project", "tasks")&.size || 0
    subtasks_count = result.dig("project", "tasks")&.sum { |t| t["sub_tasks"]&.size || 0 } || 0
    
    Rails.logger.info "✅ Parsovano: #{tasks_count} tasks, #{subtasks_count} subtasks"
    
    result
  rescue JSON::ParserError => e
    Rails.logger.error "❌ JSON greška: #{e.message}"
    Rails.logger.error "JSON string:\n#{json_str[0...1000]}"
    
    # Fallback
    {
      "project" => {
        "name" => @filename,
        "tasks" => [],
        "error" => "Greška parsiranja JSON-a"
      }
    }
  end
end