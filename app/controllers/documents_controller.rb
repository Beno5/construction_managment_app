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
        redirect_to appropriate_path,
                    notice: t('documents.messages.updated', name: @document.name)
      else
        redirect_to appropriate_path,
                    alert: t('documents.messages.update_error')
      end
    else
      # Create new document
      @document = @parent.documents.new(document_params)
      if @document.save
        redirect_to appropriate_path,
                    notice: t('documents.messages.created', name: @document.name)
      else
        flash.now[:alert] = t('documents.messages.create_error')
        render :new, status: :unprocessable_entity
      end
    end
  end

  def update
    # Check optimistic locking if record_updated_at is provided (inline editing)
    if params[:record_updated_at].present?
      record_updated_at = Time.parse(params[:record_updated_at])
      record_updated_at_sec = record_updated_at.change(usec: 0)
      document_updated_at_sec = @document.updated_at.change(usec: 0)

      if document_updated_at_sec > record_updated_at_sec
        respond_to do |format|
          format.json do
            render json: {
              success: false,
              conflict: true,
              error: t('documents.messages.conflict')
            }, status: :conflict
          end
          format.html do
            redirect_to parent_path(@document),
                        alert: t('documents.messages.conflict')
          end
        end
        return
      end
    end

    if @document.update(document_params)
      respond_to do |format|
        format.json do
          render json: {
            success: true,
            data: {
              id: @document.id,
              name: @document.name,
              description: @document.description,
              file_size: @document.file.attached? ? @document.file.byte_size : nil,
              updated_at: @document.updated_at.iso8601
            }
          }, status: :ok
        end
        format.html do
          redirect_to parent_path(@document),
                      notice: t('documents.messages.updated', name: @document.name)
        end
      end
    else
      respond_to do |format|
        format.json do
          render json: {
            success: false,
            errors: @document.errors.full_messages
          }, status: :unprocessable_entity
        end
        format.html do
          flash.now[:alert] = t('documents.messages.update_error')
          render :edit, status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    name = @document.name
    @document.destroy

    respond_to do |format|
      format.turbo_stream # koristi destroy.turbo_stream.erb ako postoji
      format.html do
        redirect_to appropriate_path,
                    notice: t('documents.messages.deleted', name: name)
      end
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

  def parent_path(_document)
    # Redirect back to the owning parent rather than the document itself
    appropriate_path
  end
end
