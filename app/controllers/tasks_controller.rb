class TasksController < ApplicationController
  before_action :set_project, except: [:gantt_data, :add_task, :update_task, :delete_task]

  before_action :set_task, only: %i[edit update destroy]

  # Standard CRUD Actions
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
      redirect_to @project, notice: 'Task je uspješno ažuriran.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    redirect_to @project, notice: 'Task je uspješno obrisan.'
  end

  # API Actions for dhtmlxGantt
  def gantt_data
    tasks = Task.all
    links = [] # Dodajte linkove ako ih budete koristili
  
    render json: {
      data: tasks.map do |task|
        {
          id: task.id,
          text: task.description,
          start_date: task.planned_start_date&.strftime("%Y-%m-%d %H:%M:%S"),
          duration: task.calculate_duration  || 1,
          progress: task.planned_cost || 0,
          parent: 0 # Prilagodite ako koristite hijerarhiju
        }
      end,
      links: links
    }
  end
  
  

  def add_task
    task = @project.tasks.new(
      description: params[:text],
      planned_start_date: params[:start_date],
      planned_cost: params[:progress] || 0
    )

    if task.save
      render json: { action: "inserted", tid: task.id }
    else
      render json: { action: "error" }
    end
  end

  def update_task
    task = @project.tasks.find(params[:id])
    if task.update(
        description: params[:text],
        planned_start_date: params[:start_date],
        planned_cost: params[:progress] || 0
      )
      render json: { action: "updated" }
    else
      render json: { action: "error" }
    end
  end

  def delete_task
    task = @project.tasks.find(params[:id])
    task.destroy
    render json: { action: "deleted" }
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_task
    @task = @project.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:description, :quantity, :unit, :planned_start_date, :planned_end_date, :planned_cost)
  end
end
