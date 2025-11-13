# app/services/ai_import_builder_service.rb
class AiImportBuilderService
  def initialize(ai_data, user:, business:)
    @data = ai_data
    @user = user
    @business = business
  end

  def build!
    project_data = @data["project"] || {}

    project = @business.projects.create!(
      name: project_data["name"].presence || "AI Imported Project",
      description: project_data["description"],
      address: project_data["address"],
      project_manager: project_data["project_manager"],
      planned_cost: project_data["planned_cost"],
      user: @user
    )

    Array(project_data["tasks"]).each do |task_data|
      task = project.tasks.create!(
        name: task_data["name"].presence || "Unnamed Task",
        description: task_data["description"],
        planned_cost: task_data["planned_cost"],
        user: @user
      )

      Array(task_data["sub_tasks"]).each do |subtask_data|
        task.sub_tasks.create!(
          name: subtask_data["name"].presence || "Unnamed SubTask",
          description: subtask_data["description"],
          unit_of_measure: map_unit(subtask_data["unit_of_measure"]),
          quantity: subtask_data["quantity"],
          price_per_unit: subtask_data["price_per_unit"],
          total_cost: subtask_data["total_cost"],
          planned_start_date: subtask_data["planned_start_date"],
          planned_end_date: subtask_data["planned_end_date"],
          custom_fields: subtask_data["custom_fields"],
          user: @user
        )
      end
    end

    project
  end

  private

  def map_unit(unit)
    return nil if unit.blank?

    normalized = unit.to_s.downcase.strip

    # ✅ KOMPLETNO MAPIRANJE SA FALLBACK-om
    case normalized
    # Komadi
    when "kom", "komad", "komada", "piece", "pieces", "pcs"
      "pieces"
    # Metri kvadratni
    when "m2", "m²", "kvadrat", "kvadrata", "sqm"
      "m2"
    # Metri kubni
    when "m3", "m³", "kub", "kubik", "cubic"
      "m3"
    # Obični metri
    when "m", "m1", "metar", "metara", "meter"
      "m"
    # Kilogrami
    when "kg", "kilogram", "kilograma"
      "kg"
    # Tone
    when "t", "ton", "tona", "tone"
      "ton"
    # Litri
    when "l", "litar", "litara", "liters", "liter"
      "liters"
    # Sati
    when "h", "sat", "sati", "hours", "hour"
      "hours"
    # Paušal
    when "pauš", "paušal", "paušalno", "pausal", "pausalno", "kom paušalno"
      "pausal"
    # Roll
    when "roll", "rola", "rolna"
      "roll"
    # Bag
    when "bag", "vreća", "vreca", "kesа"
      "bag"
    # Set
    when "set", "komplet"
      "set"
    else
      # ✅ FALLBACK - ako nije prepoznato, vrati null
      Rails.logger.warn "⚠️ Nepoznata jedinica mjere: '#{unit}' → postavljam na null"
      nil
    end
  end
end
