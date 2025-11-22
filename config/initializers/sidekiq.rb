require "sentry-sidekiq"

redis_url = ENV["REDIS_URL"] || ENV["REDISCLOUD_URL"] || "redis://localhost:6379"

Sidekiq.configure_server do |config|
  config.redis = { url: redis_url }
  config.error_handlers << Proc.new { |ex, ctx_hash| Sentry.capture_exception(ex, extra: ctx_hash) }
end

Sidekiq.configure_client do |config|
  config.redis = { url: redis_url }
end
