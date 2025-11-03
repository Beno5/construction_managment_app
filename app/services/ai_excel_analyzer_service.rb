# app/services/ai_excel_analyzer_service.rb
require "roo"
require "json"

class AiExcelAnalyzerService
  TARGET_UNITS = %w[kg m2 m3 pieces ton liters roll bag set].freeze
  CHUNK_SIZE = 200 # koliko redova po chunku šaljemo GPT-u

  def initialize(file_path)
    @file_path = Pathname.new(file_path).to_s
    @filename = File.basename(@file_path, File.extname(@file_path)).titleize
    @project_fallback_name = default_fallback_name
    @client = OpenAI_CLIENT || OpenAI::Client.new(api_key: ENV.fetch("OPENAI_API_KEY", nil))
  end

  def analyze
    chunks = flatten_excel_in_chunks(@file_path)
    all_results = []

    chunks.each_with_index do |chunk_text, i|
      prompt = build_prompt(chunk_text, chunk_number: i + 1, total_chunks: chunks.size)

      puts "📦 Sending chunk #{i + 1}/#{chunks.size} to GPT..."
      response = @client.chat.completions.create(
        model: ENV.fetch("OPENAI_MODEL", "gpt-4.1"),
        temperature: 0.2,
        messages: [
          { role: "system", content: "You are an AI that analyzes messy Excel construction files." },
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

      sheet.each_row_streaming(pad_cells: true).each_with_index do |row, i|
        values = row.map { |c| normalize_cell_value(c&.value) }
        next if values.all?(&:blank?)

        rows << "#{i + 1}\t" << values[0, 20].join("\t") << "\n"

        if (i + 1) % CHUNK_SIZE == 0
          chunks << "=== SHEET: #{sheet_name} (Part #{chunks.size + 1}) ===\n" + rows.join
          rows = []
        end
      end

      chunks << "=== SHEET: #{sheet_name} (Part #{chunks.size + 1}) ===\n" + rows.join unless rows.empty?
    end

    chunks
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
      Ti si AI koji analizira neuređene Excel predmere/predračune sa Balkana.
      Analiziraš dokument "#{@filename}" (deo #{chunk_number} od #{total_chunks}).

      Za ovaj deo, detektuj taskove i subtaskove. Vrati STROGO JSON u sledećem formatu:

      {
        "project": {
          "name": "#{@filename}",
          "tasks": [
            {
              "name": String,
              "description": String|null,
              "sub_tasks": [
                {
                  "name": String,
                  "description": String|null,
                  "unit_of_measure": String|null,
                  "quantity": Number|null
                }
              ]
            }
          ]
        }
      }

      Pravila:
      - Ne izmišljaj vrednosti.
      - Ako ne možeš da odrediš nešto, stavi null.
      - Vrati samo JSON bez dodatnog teksta.

      INPUT (deo Excel fajla):
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
