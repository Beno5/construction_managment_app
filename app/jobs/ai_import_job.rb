class AiImportJob < ApplicationJob
  queue_as :default

  def perform(tmp_path, user_id, business_id)
    Rails.logger.info "🟢 [AIImportJob] Started for file: #{tmp_path}"

    user     = User.find(user_id)
    business = Business.find(business_id)

    ai_result = AiExcelAnalyzerService.new(tmp_path).analyze
    Rails.logger.info "🤖 [AIImportJob] AI finished. Keys: #{ai_result.keys rescue 'unknown'}"

    builder = AiImportBuilderService.new(
      ai_result,
      user: user,
      business: business
    )

    project = builder.build!
    Rails.logger.info "🎉 [AIImportJob] Project created: #{project.id} - #{project.name}"

  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "❌ [AIImportJob] RecordInvalid: #{e.record.class} - #{e.record.errors.full_messages.join(', ')}"

  rescue JSON::ParserError => e
    Rails.logger.error "❌ [AIImportJob] Invalid JSON from AI: #{e.message}"

  rescue StandardError => e
    Rails.logger.error "💥 [AIImportJob] Unexpected error: #{e.class} - #{e.message}"
    Rails.logger.error e.backtrace.take(10).join("\n")
  ensure
    File.delete(tmp_path) if File.exist?(tmp_path)
    Rails.logger.info "🧹 [AIImportJob] Temp file removed: #{tmp_path}"
  end
end
