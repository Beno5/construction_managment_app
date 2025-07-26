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
    @searched_norms = Norm.search(params[:search])
    @pinned_norms = @sub_task.pinned_norms
    @norms = (@pinned_norms + @searched_norms).uniq
  end

  def new
    @sub_task = @task.sub_tasks.new
  end

  def edit; end

  def create
    @sub_task = @task.sub_tasks.new(sub_task_params)
    @sub_task.user_id = current_user.id

    if @sub_task.save
      redirect_to business_project_task_sub_task_path(@business, @task.project, @task, @sub_task),
                  notice: "Sub-task was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @sub_task.update(sub_task_params)
      SubTaskPlanningCalculator.new(@sub_task).call

      respond_to do |format|
        format.html { redirect_to... }
        format.json do
          render json: {
            success: true,
            duration: @sub_task.duration,
            num_workers_skilled: @sub_task.num_workers_skilled,
            num_workers_unskilled: @sub_task.num_workers_unskilled,
            num_machines: @sub_task.num_machines
          }
        end
      end
    else
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: { success: false }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @sub_task = @task.sub_tasks.find(params[:id])
    @sub_task.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.remove(dom_id(@sub_task))
      end
      format.html do
        redirect_to business_project_task_path(@business, @task.project, @task),
                    notice: "Sub-task was successfully deleted."
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
      :name, :description, :planned_start_date, :planned_end_date, :planned_cost,
      :duration, :num_workers_skilled, :num_workers_unskilled, :num_machines,
      :real_start_date, :real_end_date, :real_cost, :planned_auto_calculation, :real_auto_calculation,
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
end
