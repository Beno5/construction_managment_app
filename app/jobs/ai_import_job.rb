class AiImportJob < ApplicationJob
  queue_as :default

  def perform(filename, base64_data, user_id, business_id)
    Rails.logger.info "🟢 [AIImportJob] Started for file: #{filename}"

    # 1) Create temporary file
    tmp_path = Rails.root.join("tmp", "#{SecureRandom.hex}_#{filename}")
    File.binwrite(tmp_path, Base64.decode64(base64_data))
    Rails.logger.info "📂 [AIImportJob] Temp file written: #{tmp_path}"

    # 2) Load user and business
    user     = User.find(user_id)
    business = Business.find(business_id)

    # 3) AI Excel analysis
    ai_result = AiExcelAnalyzerService.new(tmp_path, filename).analyze
    Rails.logger.info "🤖 [AIImportJob] AI finished. Keys: #{begin
      ai_result.keys
    rescue StandardError
      'unknown'
    end}"

    # 4) Create project
    builder = AiImportBuilderService.new(
      ai_result,
      user: user,
      business: business
    )

    project = builder.build!
    Rails.logger.info "🎉 [AIImportJob] Project created: #{project.id} - #{project.name}"

    # 5) Send real-time notification to user
    Turbo::StreamsChannel.broadcast_append_to(
      "notifications_#{user.id}",
      target: "turbo-notifications",
      partial: "partials/turbo_notification",
      locals: {
        message: I18n.t('projects.messages.ai_import_completed', project_name: project.name)
      }
    )
    Rails.logger.info "📡 [AIImportJob] Notification sent to user #{user.id}"

    # 6) Refresh projects list for all users in this business
    projects_html = business.projects.order(created_at: :desc).map do |project|
      ApplicationController.render(
        partial: "partials/card",
        locals: { project: project }
      )
    end.join

    Turbo::StreamsChannel.broadcast_replace_to(
      "projects_#{business.id}",
      target: "projects-frame",
      html: %( <div class="grid grid-cols-1 md:grid-cols-2 gap-6 dark:bg-gray-900">#{projects_html}</div>)
    )

    Rails.logger.info "🔄 [AIImportJob] Projects list refreshed for business #{business.id}"
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "❌ [AIImportJob] RecordInvalid: #{e.record.class} - #{e.record.errors.full_messages.join(', ')}"
  rescue JSON::ParserError => e
    Rails.logger.error "❌ [AIImportJob] Invalid JSON from AI: #{e.message}"
  rescue StandardError => e
    Rails.logger.error "💥 [AIImportJob] Unexpected error: #{e.class} - #{e.message}"
    Rails.logger.error e.backtrace.take(10).join("\n")
  ensure
    if tmp_path && File.exist?(tmp_path)
      File.delete(tmp_path)
      Rails.logger.info "🧹 [AIImportJob] Temp file removed: #{tmp_path}"
    end
  end
end
