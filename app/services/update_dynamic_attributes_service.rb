# app/services/update_dynamic_attributes_service.rb
class UpdateDynamicAttributesService
  def initialize(record)
    @record = record
  end

  # Main method that triggers the update

  def update_all!
    ActiveRecord::Base.transaction do
      # First, check the type of record and update local attributes
      case @record
      when Activity
        update_sub_task_from_activity
      when SubTask
        update_sub_task
      when Task
        update_task
      when Project
        update_project
      end

      # Propagate changes "upwards" if the entity has a parent
      propagate_upwards
    end
  rescue ActiveRecord::ActiveRecordError => e
    log_error(@record.class.name.downcase, e)
  rescue StandardError => e
    log_unexpected_error(@record.class.name.downcase, e)
  end

  private

  # Example: if a change occurs on Activity, update the corresponding SubTask
  def update_sub_task_from_activity
    sub_task = @record.sub_task
    UpdateDynamicAttributesService.new(sub_task).update_all! if sub_task
  end

  # Updating SubTask entity – dynamic calculation for planned attributes
  def update_sub_task
    sub_task = @record
    planned_cost_from_resources = sub_task.activities.sum(:total_cost)

    sub_task.update_columns(planned_cost_from_resources: planned_cost_from_resources)
  rescue ActiveRecord::ActiveRecordError => e
    log_error("sub_task", e)
  rescue StandardError => e
    log_unexpected_error("sub_task", e)
  end

  # Updating Task entity – aggregates data from its SubTasks
  def update_task
    task = @record
    sub_tasks = task.sub_tasks

    # If there are no subtasks, keep user-entered values (do nothing)
    return unless sub_tasks.exists?

    attributes = {
      planned_start_date: sub_tasks.minimum(:planned_start_date),
      planned_end_date: sub_tasks.maximum(:planned_end_date),
      planned_cost: sub_tasks.sum(:planned_cost),
      planned_cost_from_resources: sub_tasks.sum(:planned_cost_from_resources),
      real_start_date: sub_tasks.minimum(:real_start_date),
      real_end_date: sub_tasks.maximum(:real_end_date),
      real_cost: sub_tasks.sum(:real_cost),
      quantity: nil,
      unit_of_measure: nil,
      price_per_unit: nil
    }

    task.update_columns(attributes)
  rescue ActiveRecord::ActiveRecordError => e
    log_error("task", e)
  rescue StandardError => e
    log_unexpected_error("task", e)
  end

  # Updating Project entity – aggregates data from its Tasks
  def update_project
    project = @record
    tasks = project.tasks
    # If there are no tasks, keep user-entered values (do nothing)
    return unless tasks.exists?

    attributes = {
      planned_start_date: tasks.minimum(:planned_start_date),
      planned_end_date: tasks.maximum(:planned_end_date),
      planned_cost: tasks.sum(:planned_cost),
      planned_cost_from_resources: tasks.sum(:planned_cost_from_resources),
      real_start_date: tasks.minimum(:real_start_date),
      real_end_date: tasks.maximum(:real_end_date),
      real_cost: tasks.sum(:real_cost)
    }

    project.update_columns(attributes)
  rescue ActiveRecord::ActiveRecordError => e
    log_error("project", e)
  rescue StandardError => e
    log_unexpected_error("project", e)
  end

  # Propagate updates to parents, e.g., when a SubTask is updated, the Task is updated,
  # and then the Project. This method checks if @record has a parent and recursively calls the service.
  def propagate_upwards
    parent = @record.try(:sub_task) || @record.try(:task) || @record.try(:project)
    UpdateDynamicAttributesService.new(parent).update_all! if parent
  end

  # Log ActiveRecord errors
  def log_error(entity, error)
    Rails.logger.error("Failed to update #{entity}: #{error.message}")
    false
  end

  # Log unexpected errors
  def log_unexpected_error(entity, error)
    Rails.logger.error("An unexpected error occurred while updating #{entity}: #{error.message}")
    false
  end
end
