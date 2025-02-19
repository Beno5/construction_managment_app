class TasksController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :set_business
  before_action :set_project
  before_action :set_task, only: %i[edit update destroy]

  def index
    @tasks = @project.tasks
  end

  def new
    @task = @project.tasks.new
    @workers = @current_business.workers
    @machines = @current_business.machines
    @materials = @current_business.materials
    @selected_workers = []
    @selected_machines = []
    @selected_materials = []
  end

  def edit
    @task = @project.tasks.find(params[:id])
    @workers = @current_business.workers
    @machines = @current_business.machines
    @materials = @current_business.materials
    @selected_workers = @task.activities.where(activity_type: :worker).pluck(:activityable_id) || []
    @selected_machines = @task.activities.where(activity_type: :machine).pluck(:activityable_id) || []
    @selected_materials = @task.activities.where(activity_type: :material).pluck(:activityable_id) || []
    @selected_workers_names = @workers.where(id: @selected_workers).map(&:full_name).join(', ')
    @selected_machines_names = @machines.where(id: @selected_machines).map(&:name).join(', ')
    @selected_materials_names = @materials.where(id: @selected_materials).map(&:name).join(', ')
  end

  def create
    @task = @project.tasks.new(task_params)
    if @task.save
      update_task_activities(@task, params[:worker_ids], params[:machine_ids])
      redirect_to business_project_path(@business, @project), notice: "Task was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      update_task_activities(@task, params[:task][:worker_ids], params[:task][:machine_ids],
                             params[:task][:material_ids], params[:task][:material_quantities])
      redirect_to business_project_path(@business, @project), notice: "Task was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(dom_id(@task)) }
      format.html { redirect_to business_project_path(@business, @project), notice: "Task was successfully deleted." }
    end
  end

  private

  def set_project
    @project = @business.projects.find(params[:project_id])
  end

  def set_task
    @task = Task.find_by(id: params[:id])
  end

  def task_params
    params.require(:task).permit(
      :name, :description, :quantity, :unit,
      :planned_start_date, :planned_end_date, :planned_cost,
      custom_fields: [:key, :value]
    ).tap do |whitelisted|
      if params[:task][:custom_fields]
        transformed_custom_fields = params[:task][:custom_fields].to_unsafe_h.each_with_object({}) do |(_, field), hash|
          hash[field["key"]] = field["value"] if field["key"].present? && field["value"].present?
        end
        whitelisted[:custom_fields] = transformed_custom_fields
      else
        whitelisted[:custom_fields] = {}
      end
    end
  end

  def update_task_activities(task, worker_ids, machine_ids, material_ids, material_quantities)
    update_activity_type(task, worker_ids, 'worker', 'Worker')
    update_activity_type(task, machine_ids, 'machine', 'Machine')
    update_activity_type(task, material_ids, 'material', 'Material', material_quantities)
  end

  def update_activity_type(task, entity_ids, activity_type, activityable_type, quantities = nil)
    current_ids = task.activities.where(activity_type: activity_type).pluck(:activityable_id)
    entity_ids = entity_ids&.map(&:to_i) || []

    new_ids = entity_ids - current_ids
    old_ids = current_ids - entity_ids

    # Kreiranje novih aktivnosti
    new_ids.each do |id|
      quantity = quantities&.dig(id.to_s)&.to_i || 0
      task.activities.create(
        activity_type: activity_type,
        start_date: task.planned_start_date,
        end_date: task.planned_end_date,
        activityable_id: id,
        activityable_type: activityable_type,
        quantity: quantity
      )
    end

    # Ažuriranje postojećih aktivnosti (ako je potrebno)
    if quantities
      task.activities.where(activity_type: activity_type, activityable_id: entity_ids).each do |activity|
        quantity = quantities&.dig(activity.activityable_id.to_s)&.to_i || 0
        activity.update(quantity: quantity)
      end
    end

    # Brisanje nepotrebnih aktivnosti
    task.activities.where(activity_type: activity_type, activityable_id: old_ids).destroy_all
  end
end
