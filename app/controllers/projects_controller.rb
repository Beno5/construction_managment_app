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
    @tasks = @project.tasks
                     .search(params[:search])
                     .order(:position)
                     .page(params[:task_page])
                     .per(10)

    @documents = @project.documents
                         .search(params[:search])
                         .order(created_at: :desc)
                         .page(params[:document_page])
                         .per(10)
  end

  def new
    @project = @business.projects.new
  end

  def edit; end

  def create
    @project = @business.projects.new(project_params)
    @project.user_id = current_user.id

    if @project.save
      redirect_to business_projects_url(@business),
                  notice: t('projects.messages.created', name: @project.name)
    else
      set_error_message
      render :new, status: :unprocessable_entity, locals: { locale: params[:locale] }
    end
  end

  def update
    if @project.update(project_params)
      redirect_to business_projects_url(@business),
                  notice: t('projects.messages.updated', name: @project.name)
    else
      set_error_message
      render :edit, status: :unprocessable_entity, locals: { locale: params[:locale] }
    end
  end

  def destroy
    name = @project.name
    @project.destroy

    respond_to do |format|
      format.turbo_stream # koristi destroy.turbo_stream.erb
      format.html do
        redirect_to business_projects_path(@business), notice: t('projects.messages.deleted', name: name)
      end
    end
  end

  def import_ai
    file = params[:file]
    if file.blank?
      redirect_to projects_path, alert: "Molimo odaberite fajl."
      return
    end

    tmp_path = Rails.root.join("tmp", file.original_filename)
    File.binwrite(tmp_path, file.read)
    Rails.logger.info "📂 [AI Import] File saved to: #{tmp_path}"

    # ⬇️ START JOB
    AiImportJob.perform_later(
      tmp_path.to_s,
      current_user.id,
      current_business.id
    )

    redirect_to business_projects_path(current_business),
                notice: "🤖 AI import je pokrenut! Projekat će se pojaviti kada analiza bude završena."
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
    if @project.errors[:name].any?
      flash.now[:alert] = @project.errors[:name].first
    elsif @project.errors[:base].any?
      flash.now[:alert] = @project.errors[:base].first
    end
  end
end
