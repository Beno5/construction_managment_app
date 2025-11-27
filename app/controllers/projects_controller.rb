class ProjectsController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :require_business
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
    # Check optimistic locking if record_updated_at is provided (inline editing)
    if params[:record_updated_at].present?
      # Parse the timestamp sent by client
      record_updated_at = Time.parse(params[:record_updated_at])

      # Truncate both timestamps to second precision to avoid microsecond comparison issues
      record_updated_at_sec = record_updated_at.change(usec: 0)
      project_updated_at_sec = @project.updated_at.change(usec: 0)

      # Only flag conflict if database timestamp is NEWER (by more than 1 second)
      if project_updated_at_sec > record_updated_at_sec
        respond_to do |format|
          format.json do
            render json: {
              success: false,
              conflict: true,
              error: 'This record was modified by another user. Please refresh the page.'
            }, status: :conflict
          end
          format.html do
            redirect_to business_projects_url(@business),
                        alert: 'This record was modified by another user. Please refresh the page.'
          end
        end
        return
      end
    end

    if @project.update(project_params)
      respond_to do |format|
        format.json do
          render json: {
            success: true,
            data: {
              id: @project.id,
              name: @project.name,
              description: @project.description,
              address: @project.address,
              project_manager: @project.project_manager,
              planned_start_date: @project.planned_start_date,
              planned_end_date: @project.planned_end_date,
              planned_cost: @project.planned_cost,
              real_start_date: @project.real_start_date,
              real_end_date: @project.real_end_date,
              real_cost: @project.real_cost,
              status: @project.status,
              updated_at: @project.updated_at.iso8601
            }
          }, status: :ok
        end
        format.html do
          redirect_to business_projects_url(@business),
                      notice: t('projects.messages.updated', name: @project.name)
        end
      end
    else
      respond_to do |format|
        format.json do
          render json: {
            success: false,
            errors: @project.errors.full_messages
          }, status: :unprocessable_entity
        end
        format.html do
          set_error_message
          render :edit, status: :unprocessable_entity, locals: { locale: params[:locale] }
        end
      end
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
      redirect_to business_projects_path(current_business), alert: "Molimo odaberite Excel fajl."
      return
    end

    # File size validation - max 20MB
    max_size = 20.megabytes
    if file.size > max_size
      redirect_to business_projects_path(current_business),
                  alert: "📁 Fajl je prevelik! Maksimalna veličina je #{max_size / 1.megabyte}MB, vaš fajl ima #{(file.size / 1.megabyte.to_f).round(2)}MB."
      return
    end

    base64_data = Base64.encode64(file.read)

    # Enqueue the job and get the job ID
    job = AiImportJob.perform_later(
      file.original_filename,
      base64_data,
      current_user.id,
      current_business.id
    )

    # Store import status in cache with job ID (expires in 30 minutes as a safety net)
    cache_key = "ai_import_in_progress_#{current_user.id}_#{current_business.id}"
    Rails.cache.write(cache_key, {
                        started_at: Time.current.iso8601,
                        filename: file.original_filename,
                        estimated_duration: 120, # seconds (2 minutes default estimate)
                        job_id: job.job_id
                      }, expires_in: 30.minutes)

    redirect_to business_projects_path(current_business),
                notice: "⏳ AI import je pokrenut… Biće gotovo uskoro!"
  end

  def import_status
    cache_key = "ai_import_in_progress_#{current_user.id}_#{current_business.id}"
    status = Rails.cache.read(cache_key)

    render json: {
      in_progress: status.present?,
      started_at: status&.dig(:started_at),
      filename: status&.dig(:filename),
      estimated_duration: status&.dig(:estimated_duration)
    }
  end

  def cancel_import
    cache_key = "ai_import_in_progress_#{current_user.id}_#{current_business.id}"
    import_data = Rails.cache.read(cache_key)

    if import_data
      job_id = import_data[:job_id]

      # Mark the job as cancelled in cache so the job can check this flag
      cancelled_key = "ai_import_cancelled_#{job_id}"
      Rails.cache.write(cancelled_key, true, expires_in: 1.hour)

      # Try to find and delete the Sidekiq job
      begin
        require 'sidekiq/api'

        # Check scheduled jobs
        scheduled_set = Sidekiq::ScheduledSet.new
        scheduled_job = scheduled_set.find { |job| job.jid == job_id }
        if scheduled_job
          scheduled_job.delete
          Rails.logger.info "🗑️  [CancelImport] Deleted scheduled Sidekiq job: #{job_id}"
        end

        # Check retry set
        retry_set = Sidekiq::RetrySet.new
        retry_job = retry_set.find { |job| job.jid == job_id }
        if retry_job
          retry_job.delete
          Rails.logger.info "🗑️  [CancelImport] Deleted retry Sidekiq job: #{job_id}"
        end

        # Check queue
        queue = Sidekiq::Queue.new('default')
        queue.each do |job|
          next unless job.jid == job_id

          job.delete
          Rails.logger.info "🗑️  [CancelImport] Deleted queued Sidekiq job: #{job_id}"
          break
        end

        # Check currently running jobs
        workers = Sidekiq::Workers.new
        workers.each do |_process_id, _thread_id, work|
          if work['payload']['jid'] == job_id
            Rails.logger.info "⚠️  [CancelImport] Job #{job_id} is currently running, marked as cancelled"
            # Job is running, can't kill it but we set the cancelled flag
          end
        end
      rescue StandardError => e
        Rails.logger.error "❌ [CancelImport] Error cancelling Sidekiq job: #{e.message}"
      end

      # Clear the cache
      Rails.cache.delete(cache_key)

      # Send Turbo Stream notification
      Turbo::StreamsChannel.broadcast_append_to(
        "notifications_#{current_user.id}",
        target: "turbo-notifications",
        partial: "partials/turbo_notification",
        locals: {
          message: "⚠️ #{t('projects.import.import_cancelled')}",
          type: "warning"
        }
      )

      render json: { success: true }
    else
      render json: { success: false, message: "No import in progress" }, status: :not_found
    end
  end

  private

  def set_business
    @business = current_user.businesses.find(params[:business_id])
    @current_business = @business  # For backward compatibility with views
  end

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
