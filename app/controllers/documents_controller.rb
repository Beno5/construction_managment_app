class DocumentsController < ApplicationController
  before_action :set_parent
  before_action :set_document, only: [:edit, :update, :destroy, :show]

  def show; end

  def new
    @document = @parent.documents.new
  end

  def edit
    @document = Document.find(params[:id])
  end

  def create
    if params[:document][:document_id].present? && params[:document][:document_id] != "undefined"
      # Update existing document
      @document = Document.find(params[:document][:document_id])
      if @document.update(document_params)
        redirect_to appropriate_path, notice: 'Resurs je uspešno ažuriran.'
      else
        redirect_to appropriate_path, alert: 'Greška pri ažuriranju resursa.'
      end
    else
      # Create new document
      @document = @parent.documents.new(document_params)
      if @document.save
        redirect_to appropriate_path, notice: 'Resurs je uspešno kreiran.'
      else
        render :new
      end
    end
  end

  def update
    if @document.update(document_params)
      redirect_to parent_path(@document), notice: 'Dokument je uspješno ažuriran.'
    else
      render :edit
    end
  end

  def destroy
    @document.destroy
    redirect_to parent_path(@document), notice: 'Dokument je uspješno obrisan.'
  end

  private

  def appropriate_path
    if @sub_task
      business_project_task_sub_task_path(@business, @project, @task, @sub_task)
    elsif @task
      business_project_task_path(@business, @project, @task)
    elsif @project
      business_project_path(@business, @project)
    else
      root_path
    end
  end

  def set_parent
    # Određivanje roditelja dokumenta (project, task, ili sub_task)
    if params[:sub_task_id]
      @sub_task = SubTask.find(params[:sub_task_id])
      @task = @sub_task.task
      @project = @task.project
      @business = @project.business
      @parent = @sub_task
    elsif params[:task_id]
      @task = Task.find(params[:task_id])
      @project = @task.project
      @business = @project.business
      @parent = @task
    else
      @project = Project.find(params[:project_id])
      @business = @project.business
      @parent = @project
    end
  end

  def set_document
    @document = @parent.documents.find(params[:id])
  end

  def document_params
    params.require(:document).permit(:name, :description, :category, :file)
  end

  def parent_path(document)
    # Dinamički generiše putanju za parent
    case document
    when SubTask
      business_project_task_sub_task_document_path(@business, @project, @task, @sub_task, document)
    when Task
      business_project_task_document_path(@business, @project, @task, document)
    when Project
      business_project_document_path(@business, @project, document)
    end
  end
end
