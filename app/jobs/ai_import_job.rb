class AiImportJob < ApplicationJob
  queue_as :default

  def perform(filename, base64_data, user_id, business_id)
    Rails.logger.info "🟢 [AIImportJob] Started for file: #{filename}"

    # Check if job was cancelled before starting
    return if cancelled?

    # 1) Create temporary file
    tmp_path = Rails.root.join("tmp", "#{SecureRandom.hex}_#{filename}")
    File.binwrite(tmp_path, Base64.decode64(base64_data))
    Rails.logger.info "📂 [AIImportJob] Temp file written: #{tmp_path}"

    # Check if job was cancelled
    return if cancelled?

    # 2) Load user and business
    user     = User.find(user_id)
    business = Business.find(business_id)

    # Check if job was cancelled
    return if cancelled?

    # 3) AI Excel analysis
    ai_result = AiExcelAnalyzerService.new(tmp_path, filename).analyze
    Rails.logger.info "🤖 [AIImportJob] AI finished. Keys: #{begin
      ai_result.keys
    rescue StandardError
      'unknown'
    end}"

    # Check if job was cancelled after AI analysis (most important check)
    if cancelled?
      Rails.logger.info "🛑 [AIImportJob] Job cancelled, skipping project creation"
      return
    end

    # 4) Create project
    builder = AiImportBuilderService.new(
      ai_result,
      user: user,
      business: business
    )

    project = builder.build!
    Rails.logger.info "🎉 [AIImportJob] Project created: #{project.id} - #{project.name}"

    # 5) Send real-time notification to user
    project_url = Rails.application.routes.url_helpers.business_project_path(business, project,
                                                                             locale: user.locale || I18n.default_locale)
    Turbo::StreamsChannel.broadcast_append_to(
      "notifications_#{user.id}",
      target: "turbo-notifications",
      partial: "partials/turbo_notification",
      locals: {
        message: I18n.t('projects.messages.ai_import_completed', project_name: project.name),
        project_url: project_url
      }
    )
    Rails.logger.info "📡 [AIImportJob] Notification sent to user #{user.id}"

    # 6) Refresh projects list for all users in this business
    projects_html = business.projects.order(created_at: :desc).map do |p|
      ApplicationController.render(
        partial: "partials/card",
        locals: { project: p, highlight: (p.id == project.id) }
      )
    end.join

    Turbo::StreamsChannel.broadcast_replace_to(
      "projects_#{business.id}",
      target: "projects-frame",
      html: %( <div class="grid grid-cols-1 md:grid-cols-2 gap-6 dark:bg-gray-900">#{projects_html}</div>)
    )

    Rails.logger.info "🔄 [AIImportJob] Projects list refreshed for business #{business.id}"

    # Clear import status from cache
    cache_key = "ai_import_in_progress_#{user_id}_#{business_id}"
    Rails.cache.delete(cache_key)
    Rails.logger.info "✅ [AIImportJob] Import status cleared from cache"
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "❌ [AIImportJob] RecordInvalid: #{e.record.class} - #{e.record.errors.full_messages.join(', ')}"

    # Clear import status from cache on validation error
    cache_key = "ai_import_in_progress_#{user_id}_#{business_id}"
    Rails.cache.delete(cache_key)

    # Send error notification to user
    if user && business
      Turbo::StreamsChannel.broadcast_append_to(
        "notifications_#{user.id}",
        target: "turbo-notifications",
        partial: "partials/turbo_notification",
        locals: {
          message: "❌ AI import neuspješan: #{e.record.errors.full_messages.join(', ')}",
          type: "error"
        }
      )
    end
  rescue JSON::ParserError => e
    Rails.logger.error "❌ [AIImportJob] Invalid JSON from AI: #{e.message}"

    # Clear import status from cache on JSON error
    cache_key = "ai_import_in_progress_#{user_id}_#{business_id}"
    Rails.cache.delete(cache_key)
  rescue StandardError => e
    Rails.logger.error "💥 [AIImportJob] Unexpected error: #{e.class} - #{e.message}"
    Rails.logger.error e.backtrace.take(10).join("\n")

    # Clear import status from cache on error as well
    cache_key = "ai_import_in_progress_#{user_id}_#{business_id}"
    Rails.cache.delete(cache_key)
  ensure
    if tmp_path && File.exist?(tmp_path)
      File.delete(tmp_path)
      Rails.logger.info "🧹 [AIImportJob] Temp file removed: #{tmp_path}"
    end
  end

  private

  def cancelled?
    cancelled_key = "ai_import_cancelled_#{job_id}"
    is_cancelled = Rails.cache.read(cancelled_key)
    Rails.logger.info "🛑 [AIImportJob] Job #{job_id} detected cancellation flag" if is_cancelled
    is_cancelled
  end
end
