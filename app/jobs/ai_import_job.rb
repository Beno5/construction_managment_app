class AiImportJob < ApplicationJob
  queue_as :default

  def perform(filename, base64_data, user_id, business_id)
    Rails.logger.info "🟢 [AIImportJob] Started for file: #{filename}"

    # 1) Napravimo privremeni fajl unutar joba
    tmp_path = Rails.root.join("tmp", "#{SecureRandom.hex}_#{filename}")
    File.binwrite(tmp_path, Base64.decode64(base64_data))
    Rails.logger.info "📂 [AIImportJob] Temp file written: #{tmp_path}"

    # 2) Učitaj korisnika i business
    user     = User.find(user_id)
    business = Business.find(business_id)

    # 3) AI Excel analiza
    ai_result = AiExcelAnalyzerService.new(tmp_path).analyze
    Rails.logger.info "🤖 [AIImportJob] AI finished. Keys: #{ai_result.keys rescue 'unknown'}"

    # 4) Kreiranje projekta
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
    if tmp_path && File.exist?(tmp_path)
      File.delete(tmp_path)
      Rails.logger.info "🧹 [AIImportJob] Temp file removed: #{tmp_path}"
    end
  end
end
