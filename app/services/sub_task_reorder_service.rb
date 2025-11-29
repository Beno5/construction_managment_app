class SubTaskReorderService
  def initialize(task, ordered_items)
    @task = task
    @ordered_items = Array(ordered_items)
  end

  def call
    SubTask.transaction do
      @ordered_items.each do |item|
        sub_task = SubTask.find(item[:id] || item["id"])
        position = item[:position] || item["position"]

        raise ActiveRecord::RecordNotFound unless sub_task.task.project_id == @task.project_id

        sub_task.update_columns(task_id: @task.id, position: position, updated_at: Time.current)
      end
    end
  end
end
