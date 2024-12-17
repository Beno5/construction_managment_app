class TasksController < ApplicationController
  before_action :set_project
  before_action :set_task, only: %i[edit update destroy]

  def new
    @task = @project.tasks.new
  end

  def edit; end

  def create
    @task = @project.tasks.new(task_params)
    if @task.save
      flash[:success] = "Uspješno ste dodali aktivnost #{@task.description}."
      redirect_to new_project_task_path(@project, show_modal: true)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      redirect_to @project, notice: 'Task je uspešno ažuriran.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    redirect_to @project, notice: 'Task je uspešno obrisan.'
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_task
    @task = @project.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:description, :quantity, :unit, :planned_start, :planned_end, :duration, :planned_cost)
  end
end
