class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  # Display all projects
  def index
    @projects = Project.all
  end

  # Display a single project
  def show; end

  # Show the form for creating a new project
  def new
    @project = Project.new
  end

  # Show the form for editing a project
  def edit; end

  # Create a new project
  def create
    @project = Project.new(project_params)
    if @project.save
      redirect_to projects_url, notice: 'Project was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # Update an existing project
  def update
    if @project.update(project_params)
      redirect_to projects_url, notice: 'Project was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # Delete a project
  def destroy
    @project.destroy
    redirect_to projects_url, notice: 'Project was successfully deleted.'
  end

  private

  # Find the project by ID
  def set_project
    @project = Project.find(params[:id])
  end

  # Allow only permitted parameters for a project
  def project_params
    params.require(:project).permit(
      :name,
      :project_type,
      :address,
      :project_manager,
      :planned_start_date,
      :planned_end_date,
      :estimated_cost,
      :description,
      :status,
      :attachment
    )
  end
end
