class TasksController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :require_business
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
    @documents = @task.documents.with_attached_file.search(params[:search]).order(created_at: :desc).page(params[:document_page]).per(10)
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
      respond_to do |format|
        format.turbo_stream
        format.html do
          redirect_to business_project_path(@business, @project),
                      notice: t('tasks.messages.created', name: @task.name)
        end
      end
    else
      set_error_message
      render :new, status: :unprocessable_entity
    end
  end

  def update
    # Check optimistic locking if record_updated_at is provided (inline editing)
    if params[:record_updated_at].present?
      # Parse the timestamp sent by client
      record_updated_at = Time.parse(params[:record_updated_at])

      # Truncate both timestamps to second precision to avoid microsecond comparison issues
      record_updated_at_sec = record_updated_at.change(usec: 0)
      task_updated_at_sec = @task.updated_at.change(usec: 0)

      # Only flag conflict if database timestamp is NEWER (by more than 1 second)
      if task_updated_at_sec > record_updated_at_sec
        respond_to do |format|
          format.json do
            render json: {
              success: false,
              conflict: true,
              error: t("tasks.messages.conflict")
            }, status: :conflict
          end
          format.html do
            redirect_back fallback_location: root_path,
                          alert: t("tasks.messages.conflict")
          end
        end
        return
      end
    end

    if @task.update(task_params)
      respond_to do |format|
        format.json do
          render json: {
            success: true,
            data: {
              id: @task.id,
              name: @task.name,
              position: @task.position,
              planned_start_date: @task.planned_start_date,
              planned_end_date: @task.planned_end_date,
              planned_cost: @task.planned_cost,
              description: @task.description,
              custom_fields: @task.custom_fields,
              updated_at: @task.updated_at.iso8601
            }
          }, status: :ok
        end
        format.html do
          redirect_back fallback_location: root_path,
                        notice: t("tasks.messages.updated", name: @task.name)
        end
      end
    else
      respond_to do |format|
        format.json do
          render json: {
            success: false,
            errors: @task.errors.full_messages
          }, status: :unprocessable_entity
        end
        format.html do
          render :edit, status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    # Store name and ID before destroying
    @deleted_item_name = @task.name
    @deleted_item_id = dom_id(@task)

    # Store task index for removing subtask rows with class 'sub-tasks-of-X'
    # This matches the table structure where subtasks have class based on task index
    @task_index = @project.tasks.order(:position).index(@task)

    @task.destroy

    respond_to do |format|
      format.turbo_stream do
        # Prevent Turbo Frame caching to ensure fresh renders on subsequent deletions
        response.headers['X-Turbo-Cache-Control'] = 'no-cache'
        response.headers['Cache-Control'] = 'no-cache, no-store, must-revalidate'

        # Reload tasks for table frame replacement (updates position numbers)
        @tasks = @project.tasks.order(:position)

        render "projects/show"
      end
      format.html do
        redirect_to business_project_path(@business, @project, anchor: 'tasks'),
                    notice: t('tasks.messages.deleted', name: @deleted_item_name)
      end
    end
  end

  def reorder
    service = TaskReorderService.new(@project, reorder_params[:order])
    service.call

    render json: { success: true }
  rescue StandardError => e
    render json: { success: false, error: e.message }, status: :unprocessable_entity
  end

  private

  def set_business
    @business = current_user.businesses.find(params[:business_id])
    @current_business = @business  # For backward compatibility with views
  end

  def set_project
    @project = @business.projects.find(params[:project_id])
  end

  def set_task
    @task = @project.tasks.find(params[:id])
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
      :unit_of_measure, :quantity, :price_per_unit,
      :real_start_date, :real_end_date, :real_cost,
      custom_fields: {}
    ).tap do |whitelisted|
      if params[:task][:custom_fields]
        custom_fields_param = params[:task][:custom_fields].to_unsafe_h

        # Handle two formats:
        # 1. Array format from forms: [{key: "name", value: "val"}, ...]
        # 2. Hash format from inline editing: {field_name: "value"}
        if custom_fields_param.values.first.is_a?(Hash) && custom_fields_param.values.first.key?("key")
          # Array format from forms
          transformed_custom_fields = custom_fields_param.each_with_object({}) do |(_, field), hash|
            hash[field["key"]] = field["value"] if field["key"].present? && field["value"].present?
          end
          whitelisted[:custom_fields] = transformed_custom_fields
        else
          # Hash format from inline editing - merge with existing
          whitelisted[:custom_fields] = @task.custom_fields.merge(custom_fields_param)
        end
      else
        whitelisted[:custom_fields] = {}
      end
    end
  end

  def reorder_params
    params.permit(order: %i[id position])
  end
end
