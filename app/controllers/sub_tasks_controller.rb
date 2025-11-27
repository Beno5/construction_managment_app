class SubTasksController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :require_business
  before_action :set_business
  before_action :set_project
  before_action :set_task

  before_action :set_sub_task, only: %i[show edit update destroy]

  def index
    @sub_tasks = @task.sub_tasks
  end

  def show
    @activities = Kaminari.paginate_array(@sub_task.activities.search(params[:search])).page(params[:activity_page]).per(10)
    @documents = @sub_task.documents.with_attached_file.search(params[:search]).order(created_at: :desc).page(params[:document_page]).per(10)

    # 🔹 Ispravna verzija — paginacija na kraju
    @searched_norms = current_business.norms.search(params[:norm_search])
    @pinned_norms   = @sub_task.pinned_norms
    combined_norms  = (@pinned_norms + @searched_norms).uniq

    @norms = Kaminari.paginate_array(combined_norms).page(params[:norm_page]).per(10)

    @readonly_mode = false
  end

  def new
    @sub_task = @task.sub_tasks.new
    @readonly_mode = true
  end

  def edit; end

  def create
    @sub_task = @task.sub_tasks.new(sub_task_params)
    @sub_task.user_id = current_user.id

    if @sub_task.save
      redirect_to business_project_path(@business, @project),
                  notice: t('subtasks.messages.created', name: @sub_task.name)
    else
      set_error_message
      render :show, status: :unprocessable_entity
    end
  end

  def update
    # Check optimistic locking if record_updated_at is provided (inline editing)
    if params[:record_updated_at].present?
      # Parse the timestamp sent by client
      record_updated_at = Time.parse(params[:record_updated_at])

      # Truncate both timestamps to second precision to avoid microsecond comparison issues
      record_updated_at_sec = record_updated_at.change(usec: 0)
      sub_task_updated_at_sec = @sub_task.updated_at.change(usec: 0)

      # Only flag conflict if database timestamp is NEWER (by more than 1 second)
      if sub_task_updated_at_sec > record_updated_at_sec
        respond_to do |format|
          format.json do
            render json: {
              success: false,
              conflict: true,
              error: 'This record was modified by another user. Please refresh the page.'
            }, status: :conflict
          end
          format.html do
            redirect_back fallback_location: root_path,
                          alert: 'This record was modified by another user. Please refresh the page.'
          end
        end
        return
      end
    end

    if @sub_task.update(sub_task_params)
      # Calculate planning attributes using the service
      SubTaskPlanningCalculator.new(@sub_task).call
      # Reload task to get updated aggregated values
      @task.reload

      respond_to do |format|
        format.json do
          render json: {
            success: true,
            data: {
              id: @sub_task.id,
              name: @sub_task.name,
              position: @sub_task.position,
              planned_start_date: @sub_task.planned_start_date,
              planned_end_date: @sub_task.planned_end_date,
              duration: @sub_task.duration,
              description: @sub_task.description,
              quantity: @sub_task.quantity,
              planned_cost: @sub_task.planned_cost,
              price_per_unit: @sub_task.price_per_unit,
              unit_of_measure: @sub_task.unit_of_measure,
              num_workers_skilled: @sub_task.num_workers_skilled,
              num_workers_unskilled: @sub_task.num_workers_unskilled,
              num_machines: @sub_task.num_machines,
              formatted_duration: view_context.formatted_duration_days_hours(@sub_task.duration, @business),
              updated_at: @sub_task.updated_at.iso8601,
              task: {
                id: @task.id,
                url: business_project_task_path(@business, @task.project, @task),
                planned_start_date: @task.planned_start_date,
                planned_end_date: @task.planned_end_date,
                planned_cost: @task.planned_cost,
                updated_at: @task.updated_at.iso8601
              }
            }
          }, status: :ok
        end
        format.html do
          redirect_to business_project_path(@business, @project),
                      notice: t('subtasks.messages.updated', name: @sub_task.name)
        end
      end
    else
      respond_to do |format|
        format.html do
          set_error_message
          render :edit, status: :unprocessable_entity
        end
        format.json do
          render json: {
            success: false,
            errors: @sub_task.errors.full_messages
          }, status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    @sub_task = @task.sub_tasks.find(params[:id])
    # Store name and ID before destroying
    @deleted_item_name = @sub_task.name
    @deleted_item_id = dom_id(@sub_task)

    @sub_task.destroy

    respond_to do |format|
      format.turbo_stream do
        # Prevent Turbo Frame caching to ensure fresh renders on subsequent deletions
        response.headers['X-Turbo-Cache-Control'] = 'no-cache'
        response.headers['Cache-Control'] = 'no-cache, no-store, must-revalidate'

        @project = @task.project

        # Differentiate between views
        if params[:delete_from_project] == "true"
          # Called from project#show - frame replacement for position updates
          # Reload tasks for table frame replacement (updates position numbers)
          @tasks = @project.tasks.order(:position)

          render "projects/show"
        else
          # Called from task#show - subtask table refresh
          render "sub_tasks/destroy"
        end
      end

      format.html do
        redirect_to business_project_task_path(@business, @project, @task),
                    notice: t('subtasks.messages.deleted', name: @deleted_item_name)
      end
    end
  end

  private

  def set_business
    @business = current_user.businesses.find(params[:business_id])
    @current_business = @business # For backward compatibility with views
  end

  def set_task
    @task = @project.tasks.find(params[:task_id])
  end

  def set_project
    @project = @business.projects.find(params[:project_id])
  end

  def set_sub_task
    @sub_task = @task.sub_tasks.find(params[:id])
  end

  def sub_task_params
    params.require(:sub_task).permit(
      :name, :description, :planned_start_date, :planned_end_date, :planned_cost, :price_per_unit, :unit_of_measure, :quantity,
      :duration, :num_workers_skilled, :num_workers_unskilled, :num_machines,
      custom_fields: [:key, :value]
    ).tap do |whitelisted|
      if params[:sub_task][:custom_fields]
        transformed_custom_fields = params[:sub_task][:custom_fields].to_unsafe_h.each_with_object({}) do |(_, field), hash|
          hash[field["key"]] = field["value"] if field["key"].present? && field["value"].present?
        end
        whitelisted[:custom_fields] = transformed_custom_fields
      else
        whitelisted[:custom_fields] = {}
      end
    end
  end

  def set_error_message
    flash.now[:alert] = if @sub_task.errors[:name].any?
                          t('subtasks.errors.name_required')
                        elsif @sub_task.errors[:base].any?
                          @sub_task.errors[:base].first
                        else
                          t('subtasks.errors.validation_failed')
                        end
  end
end
