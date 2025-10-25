class TasksController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :set_business
  before_action :set_project
  before_action :set_task, only: %i[edit update destroy]

  def index
    @tasks = @project.tasks
  end

  def show
    @project = @business.projects.find(params[:project_id])
    @task = @project.tasks.find(params[:id])
    @subtasks = @task.sub_tasks.search(params[:search]).order(:position).page(params[:subtask_page]).per(10)
    @documents = @task.documents.search(params[:search]).order(created_at: :desc).page(params[:document_page]).per(10)
    @readonly_mode = false
  end

  def new
    @task = @project.tasks.build
    @subtasks = @task.sub_tasks || SubTask.none
    @documents = Document.none
    @readonly_mode = true
  end

  def edit
    @task = @project.tasks.find(params[:id])
  end

  def create
    @task = @project.tasks.new(task_params)
    @task.user_id = current_user.id

    if @task.save
      redirect_to business_project_path(@business, @project),
                  notice: t('tasks.messages.created', name: @task.name)
    else
      set_error_message
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      redirect_to business_project_path(@business, @project),
                  notice: t('tasks.messages.updated', name: @task.name)
    else
      set_error_message
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    name = @task.name
    @task.destroy

    respond_to do |format|
      format.turbo_stream do
        @tasks = @project.tasks.order(:position)
        render "projects/show"
      end
      format.html do
        redirect_to business_project_path(@business, @project, anchor: 'tasks'),
                    notice: t('tasks.messages.deleted', name: name)
      end
    end
  end

  private

  def set_project
    @project = @business.projects.find(params[:project_id])
  end

  def set_task
    @task = Task.find_by(id: params[:id])
  end

  def set_error_message
    flash.now[:alert] = if @task.errors[:name].any?
                          t('tasks.errors.name_required')
                        elsif @task.errors[:base].any?
                          @task.errors[:base].first
                        else
                          t('tasks.errors.validation_failed')
                        end
  end

  def task_params
    params.require(:task).permit(
      :name, :description, :planned_start_date, :planned_end_date, :planned_cost,
      :real_start_date, :real_end_date, :real_cost,
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
end
