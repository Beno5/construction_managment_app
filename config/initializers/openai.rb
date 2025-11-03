# config/initializers/openai.rb
if ENV["OPENAI_API_KEY"].present?
  OpenAI_CLIENT = OpenAI::Client.new(api_key: ENV["OPENAI_API_KEY"])
  Rails.logger.info "✅ OpenAI client initialized successfully"
else
  Rails.logger.warn "⚠️ OpenAI API key not found — AI features will be disabled."
  OpenAI_CLIENT = nil
end
