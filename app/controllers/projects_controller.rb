class ProjectsController < ApplicationController
  before_action :set_current_business
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def index
    @projects = @current_business.projects
  end

  def show; end

  def new
    @project = @current_business.projects.new
  end

  def edit; end

  def create
    @project = @current_business.projects.new(project_params)
    if @project.save
      redirect_to business_projects_url(@current_business), notice: 'Project was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @project.update(project_params)
      redirect_to business_projects_url(@current_business), notice: 'Project was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy
    redirect_to business_projects_url(@current_business), notice: 'Project was successfully deleted.'
  end

  private

  def set_current_business
    @current_business = current_user.businesses.find(params[:business_id])
  end

  def set_project
    @project = @current_business.projects.find(params[:id])
  end

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
