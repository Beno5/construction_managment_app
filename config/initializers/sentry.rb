# frozen_string_literal: true

Sentry.init do |config|
  config.dsn = ENV["SENTRY_DSN"]
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]
  config.send_default_pii = true

  # performance sampling (light)
  config.traces_sample_rate = 0.1

  # disable profiling
  config.profiles_sample_rate = 0.0
end
