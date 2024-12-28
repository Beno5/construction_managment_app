class TasksController < ApplicationController
  before_action :set_business
  before_action :set_project
  before_action :set_task, only: %i[edit update destroy]

  def index
    @tasks = @project.tasks
  end

  def new
    @task = @project.tasks.new
  end

  def edit; end

  def create
    @task = @project.tasks.new(task_params)
    if @task.save
      redirect_to business_project_path(@business, @project), notice: 'Task was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      redirect_to business_project_path(@business, @project), notice: 'Task was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end
  

  def destroy
    @task.destroy
    redirect_to business_project_tasks_path(@business, @project), notice: 'Task was successfully deleted.'
  end

  private

  def set_project
    @project = @business.projects.find(params[:project_id])
  end

  def set_task
    @task = @project.tasks.find(params[:id])
  end


  def task_params
    params.require(:task).permit(
      :name, :description, :quantity, :unit, 
      :planned_start_date, :planned_end_date, :planned_cost,
      custom_fields: [:key, :value]
    ).tap do |whitelisted|
      if params[:task][:custom_fields]
        # Transformacija custom fields u hash
        transformed_custom_fields = params[:task][:custom_fields].to_unsafe_h.each_with_object({}) do |(_, field), hash|
          hash[field["key"]] = field["value"] if field["key"].present? && field["value"].present?
        end
        whitelisted[:custom_fields] = transformed_custom_fields
      else
        # Ako `custom_fields` nije prisutan, postavi ga na prazan hash
        whitelisted[:custom_fields] = {}
      end
    end
  end
  
end
