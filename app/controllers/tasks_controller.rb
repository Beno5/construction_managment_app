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
      redirect_to business_project_tasks_path(@business, @project), notice: 'Task was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      redirect_to business_project_tasks_path(@business, @project), notice: 'Task was successfully updated.'
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
    params.require(:task).permit(:description, :quantity, :unit, :planned_start_date, :planned_end_date, :planned_cost)
  end
end
