class ProjectsController < ApplicationController
  before_action :set_business
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def index
    @projects = @business.projects.search(params[:search])
  end

  def show
    @tasks = @project.tasks.search(params[:search]) # Pretraga taskova vezanih za projekat
  end

  def new
    @project = @business.projects.new
  end

  def edit; end

  def create
    @project = @business.projects.new(project_params)
    if @project.save
      redirect_to business_projects_url(@business), notice: 'Project was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @project.update(project_params)
      redirect_to business_projects_url(@business), notice: 'Project was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy
    redirect_to business_projects_url(@business), notice: 'Project was successfully deleted.'
  end

  private

  def set_project
    @project = @business.projects.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :project_type, :address, :project_manager, :planned_start_date,
                                    :planned_end_date, :estimated_cost, :description, :status, :attachment)
  end
end
