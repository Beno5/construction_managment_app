# app/services/ai_import_builder_service.rb
class AiImportBuilderService
  def initialize(ai_data, user:, business:)
    @data = ai_data
    @user = user
    @business = business
  end

  def build!
    project_data = @data["project"] || {}

    # Generate unique project name to avoid validation errors
    project_name = generate_unique_project_name(
      project_data["name"].presence || "AI Imported Project"
    )

    project = @business.projects.create!(
      name: project_name,
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

  def generate_unique_project_name(base_name)
    # Check if project with this name already exists in the business
    return base_name unless @business.projects.exists?(name: base_name)

    # If exists, append "_copy" with next available number
    counter = 1
    loop do
      new_name = "#{base_name}_copy_#{counter}"
      break new_name unless @business.projects.exists?(name: new_name)

      counter += 1
    end
  end

  def map_unit(unit)
    return nil if unit.blank?

    normalized = unit.to_s.downcase.strip

    # Map various input formats to SubTask enum keys
    case normalized
    # Meters (m)
    when "m", "m1", "metar", "metara", "meter", "meters"
      "m"

    # Square meters (m2)
    when "m2", "m²", "kvadrat", "kvadrata", "sqm", "square meter", "square meters"
      "m2"

    # Cubic meters (m3)
    when "m3", "m³", "kub", "kubik", "cubic", "cubic meter", "cubic meters"
      "m3"

    # Kilograms (kg)
    when "kg", "kilogram", "kilograma", "kilograms"
      "kg"

    # Tons (ton)
    when "t", "ton", "tona", "tone", "tons"
      "ton"

    # Pieces (pieces)
    when "kom", "komad", "komada", "piece", "pieces", "pcs", "stk", "stück"
      "pieces"

    # Liters (liters)
    when "l", "litar", "litara", "liters", "liter", "lit"
      "liters"

    # Roll (roll)
    when "roll", "rola", "rolna", "rolls"
      "roll"

    # Bag (bag)
    when "bag", "vreća", "vreca", "kesa", "bags", "vrece"
      "bag"

    # Set (set)
    when "set", "komplet", "sets"
      "set"

    # Hours (hours)
    when "h", "sat", "sati", "hours", "hour", "hr", "hrs"
      "hours"

    # Pauschal (pauschal) - FIXED typo from 'pausal' to 'pauschal'
    when "pauš", "paušal", "paušalno", "pausal", "pausalno", "pauschal", "kom paušalno", "flat rate", "lump sum"
      "pauschal"

    else
      # Fallback - log warning and return nil
      Rails.logger.warn "⚠️ [AIImport] Unknown unit: '#{unit}' → setting to null"
      nil
    end
  end
end
