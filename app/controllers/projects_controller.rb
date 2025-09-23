class ProjectsController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :set_business
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def index
    @projects = @business.projects.search(params[:search])

    respond_to do |format|
      format.html # Renderuje standardni HTML za klasične prelaze
      format.turbo_stream # Renderuje Turbo Stream za pretragu
    end
  end

  def show
    @tasks = @project.tasks.search(params[:search])
    @documents = @project.documents.search(params[:search])
  end

  def new
    @project = @business.projects.new
  end

  def edit; end

  def create
    @project = @business.projects.new(project_params)
    @project.user_id = current_user.id

    if @project.save
      redirect_to business_projects_url(@business), notice: t('projects.messages.created')
    else
      set_error_message
      render :new, status: :unprocessable_entity, locals: { locale: params[:locale] }
    end
  end

  def update
    if @project.update(project_params.except(:documents)) # Ažuriraj sve osim dokumenata
      if params[:project][:documents].present?
        existing_filenames = @project.documents.map { |doc| doc.filename.to_s }

        params[:project][:documents].each do |new_file|
          # Provjera da li je fajl validan i da nije duplikat
          if new_file.is_a?(ActionDispatch::Http::UploadedFile) && !existing_filenames.include?(new_file.original_filename)
            @project.documents.attach(new_file) # Dodaj nove fajlove
          end
        end
      end

      redirect_to business_projects_url(@business), notice: t('projects.messages.updated')
    else
      set_error_message
      render :edit, status: :unprocessable_entity, locals: { locale: params[:locale] }
    end
  end

  def destroy
    @project = @business.projects.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.turbo_stream # Ovo koristi destroy.turbo_stream.erb za uklanjanje kartice
      format.html { redirect_to business_projects_path(@business), notice: t('projects.messages.deleted') }
    end
  end

  def remove_document
    @project = @business.projects.find(params[:id])
    document = @project.documents.find_by(id: params[:document_id])

    if document
      document.purge
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.remove("document-#{params[:document_id]}")
        end
        format.html do
          redirect_to edit_business_project_path(@business, @project), notice: "Document deleted successfully."
        end
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("document-#{params[:document_id]}",
                                                    partial: "partials/error_message",
                                                    locals: { message: "Document not found." })
        end
        format.html { redirect_to edit_business_project_path(@business, @project), alert: "Document not found." }
      end
    end
  end

  private

  def set_project
    @project = @business.projects.find(params[:id])
  end

  def project_params
    params.require(:project).permit(
      :name,
      :address,
      :project_manager,
      :planned_start_date,
      :planned_end_date,
      :planned_cost, # Dodato real_cost
      :description,
      :status,
      :client_project_id,
      documents: [],
      custom_fields: [:key, :value]
    ).tap do |whitelisted|
      if params[:project][:custom_fields]
        transformed_custom_fields = params[:project][:custom_fields].to_unsafe_h.each_with_object({}) do |(_, field), hash|
          hash[field["key"]] = field["value"] if field["key"].present? && field["value"].present?
        end
        whitelisted[:custom_fields] = transformed_custom_fields
      else
        whitelisted[:custom_fields] = {}
      end
    end
  end

  def set_error_message
    flash.now[:alert] = if @project.errors[:name].any?
                          t('projects.errors.name_required')
                        elsif @project.errors[:client_project_id].any?
                          t('projects.errors.client_project_id_required')
                        elsif @project.errors[:base].any?
                          @project.errors[:base].first
                        else
                          t('projects.errors.validation_failed')
                        end
  end
end
