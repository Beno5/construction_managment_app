class SubTasksController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :set_business
  before_action :set_project
  before_action :set_task

  before_action :set_sub_task, only: %i[show edit update destroy]

  def index
    @sub_tasks = @task.sub_tasks
  end

  def show
    @activities = @sub_task.activities.search(params[:search])
    @documents = @sub_task.documents.search(params[:search])
    @searched_norms = current_business.norms.search(params[:search])
    @pinned_norms = @sub_task.pinned_norms
    @norms = (@pinned_norms + @searched_norms).uniq
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
      redirect_to business_project_task_sub_task_path(@business, @task.project, @task, @sub_task),
                  notice: t('subtasks.messages.created')
    else
      set_error_message
      render :show, status: :unprocessable_entity
    end
  end

  def update
    if @sub_task.update(sub_task_params)
      SubTaskPlanningCalculator.new(@sub_task).call

      respond_to do |format|
        format.html do
          redirect_to business_project_task_sub_task_path(@business, @task.project, @task, @sub_task),
                      notice: t('subtasks.messages.updated')
        end
        format.json do
          render json: {
            success: true,
            duration: @sub_task.duration,
            num_workers_skilled: @sub_task.num_workers_skilled,
            num_workers_unskilled: @sub_task.num_workers_unskilled,
            num_machines: @sub_task.num_machines,
            planned_start_date: @sub_task.planned_start_date&.strftime("%Y-%m-%d"),
            planned_end_date: @sub_task.planned_end_date&.strftime("%Y-%m-%d")
          }
        end
      end
    else
      respond_to do |format|
        format.html do
          set_error_message
          render :edit, status: :unprocessable_entity
        end
        format.json { render json: { success: false }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @sub_task = @task.sub_tasks.find(params[:id])
    @sub_task.destroy

    respond_to do |format|
      format.turbo_stream do
        @project = @task.project

        # 🧠 razlikuj viewe
        if params[:delete_from_project] == "true"
          # dolazi iz project#show
          @tasks = @project.tasks.order(:position)
          render "projects/show"
        else
          # dolazi iz task#show
          render "sub_tasks/destroy"
        end
      end

      format.html do
        redirect_to business_project_task_path(@business, @project, @task),
                    notice: t('sub_tasks.messages.deleted')
      end
    end
  end

  private

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
