# app/services/ai_excel_analyzer_service.rb
require "roo"
require "json"

class AiExcelAnalyzerService
  TARGET_UNITS = %w[kg m2 m3 pieces ton liters roll bag set].freeze

  def initialize(file_path, project_fallback_name = "Unnamed Project")
    @file_path = Pathname.new(file_path).to_s
    @project_fallback_name = project_fallback_name
    @client = OpenAI_CLIENT || OpenAI::Client.new(api_key: ENV.fetch("OPENAI_API_KEY", nil))
  end

  # Glavna metoda
  def analyze
    flat_text = flatten_excel(@file_path)
    prompt = build_prompt(flat_text)

    response = @client.chat.completions.create(
      model: "gpt-4o-mini",
      temperature: 0.2,
      messages: [
        { role: "system", content: "You are an AI that analyzes messy Excel construction files." },
        { role: "user", content: prompt }
      ]
    )

    raw = response.choices.first.message[:content]
    parse_json_safe(raw)
  end

  private

  # Parsiranje JSON odgovora uz fallback
  def parse_json_safe(raw)
    JSON.parse(raw)
  rescue JSON::ParserError
    # pokušaj izvući JSON ako model vrati s komentarima ili dodatnim tekstom
    json_str = raw.match(/\{.*\}/m)&.to_s
    json_str ? JSON.parse(json_str) : { error: "Invalid JSON response", raw: raw }
  end

  # Pretvori sve sheetove u čitljiv tekst za GPT
  def flatten_excel(path)
    xls = Roo::Spreadsheet.open(path)
    out = +""

    xls.sheets.each do |sheet_name|
      sheet = xls.sheet(sheet_name)
      out << "\n=== SHEET: #{sheet_name} ===\n"

      sheet.each_row_streaming(pad_cells: true).first(200).each_with_index do |row, i|
        values = row.map { |c| normalize_cell_value(c&.value) }
        next if values.all?(&:blank?)

        out << "#{i + 1}\t" << values[0, 20].join("\t") << "\n"
      end
    end

    out
  end

  # Normalizacija pojedinačne ćelije
  def normalize_cell_value(value)
    case value
    when Date
      value.strftime("%Y-%m-%d")
    when BigDecimal, Float
      value.to_f.round(2)
    else
      value.to_s.strip.gsub(/\s+/, " ")
    end
  end

  # Prompt za AI
  def build_prompt(flat_text)
    <<~PROMPT
      Ti si AI koji analizira neuređene Excel predmere/predračune sa Balkana.
      Iz sledećeg teksta (to je sirovi ispis Excel sheet-ova) detektuj projekat, taskove (glavne sekcije) i subtaskove (pojedinačne pozicije).
      Vrati STROGO JSON sa sledećim ključevima i bez dodatnog teksta:

      {
        "project": {
          "name": String,
          "description": String|null,
          "address": String|null,
          "project_manager": String|null,
          "planned_cost": Number|null,
          "tasks": [
            {
              "name": String,
              "description": String|null,
              "planned_cost": Number|null,
              "sub_tasks": [
                {
                  "name": String,
                  "description": String|null,
                  "unit_of_measure": "kg"|"m2"|"m3"|"pieces"|"ton"|"liters"|"roll"|"bag"|"set"|null,
                  "quantity": Number|null,
                  "price_per_unit": Number|null,
                  "total_cost": Number|null,
                  "planned_start_date": "YYYY-MM-DD"|null,
                  "planned_end_date": "YYYY-MM-DD"|null,
                  "custom_fields": Object|null
                }
              ]
            }
          ]
        }
      }

      Pravila:
      - Hijerarhiju prepoznaj iz naslova/sekcija (npr. A., B., PRIPREMNI RADOVI...) kao Task; stavke ispod su SubTask.
      - Jedinice mjere mapiraj u skup: #{TARGET_UNITS.join(', ')}; ako vidiš „kom“, mapiraj u "pieces"; „m1“ tretiraj kao "m".
      - Brojeve i datume normalizej (decimalna tačka, YYYY-MM-DD). Ako ne možeš pouzdano izvući, stavi null.
      - Ako se projekt ne može pouzdano imenovati, stavi "name": "#{@project_fallback_name}".
      - Ne izmišljaj vrijednosti.
      - Vrati samo JSON (bez komentara, objašnjenja ili teksta izvan JSON-a).

      INPUT (sirovi Excel kao tekst):
      #{flat_text}
    PROMPT
  end
end
