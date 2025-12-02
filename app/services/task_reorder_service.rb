class TaskReorderService
  def initialize(project, ordered_items)
    @project = project
    @ordered_items = Array(ordered_items)
  end

  def call
    Task.transaction do
      @ordered_items.each do |item|
        task = @project.tasks.find(item[:id] || item["id"])
        position = item[:position] || item["position"]
        task.update_columns(position: position, updated_at: Time.current)
      end
    end
  end
end
