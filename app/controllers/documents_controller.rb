class DocumentsController < ApplicationController
  before_action :set_document, only: [:edit, :update, :destroy, :show]
  before_action :set_parent, only: [:edit, :update, :destroy, :show, :new, :create]

  def show; end

  def new
    @document = @parent.documents.new
  end

  def edit; end

  def create
    if params[:document][:document_id].present? && params[:document][:document_id] != "undefined"
      # Update existing document
      @document = Document.find(params[:document][:document_id])
      if @document.update(document_params)
        redirect_to appropriate_path, notice: 'Dokument je uspešno ažuriran.'
      else
        redirect_to appropriate_path, alert: 'Greška pri ažuriranju Dokumenta.'
      end
    else
      # Create new document
      @document = @parent.documents.new(document_params)
      if @document.save
        redirect_to appropriate_path, notice: 'Dokument je uspešno kreiran.'
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

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.remove(@document)
      end
      format.html { redirect_to appropriate_path, notice: "Document was successfully deleted." }
    end
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
    if @document
      find_parent_by_document
    else
      find_parent_by_params
    end
  end

  def find_parent_by_document
    if @document.sub_task_id
      set_sub_task_parent(@document.sub_task_id)
    elsif @document.task_id
      set_task_parent(@document.task_id)
    elsif @document.project_id
      set_project_parent(@document.project_id)
    else
      raise ActiveRecord::RecordNotFound, "Parent not found"
    end
  end

  def find_parent_by_params
    if params[:sub_task_id]
      set_sub_task_parent(params[:sub_task_id])
    elsif params[:task_id]
      set_task_parent(params[:task_id])
    elsif params[:project_id]
      set_project_parent(params[:project_id])
    else
      raise ActiveRecord::RecordNotFound, "Parent not found"
    end
  end

  def set_sub_task_parent(sub_task_id)
    @sub_task = SubTask.find(sub_task_id)
    @task = @sub_task.task
    @project = @task.project
    @business = @project.business
    @parent = @sub_task
  end

  def set_task_parent(task_id)
    @task = Task.find(task_id)
    @project = @task.project
    @business = @project.business
    @parent = @task
  end

  def set_project_parent(project_id)
    @project = Project.find(project_id)
    @business = @project.business
    @parent = @project
  end

  def set_document
    @document = Document.find_by(id: params[:id])
  end

  def document_params
    params.require(:document).permit(:name, :description, :category, :file)
  end

  def parent_path(document)
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
