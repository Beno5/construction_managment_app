# frozen_string_literal: true

heroku_environment = ENV["DYNO"].present? || ENV["HEROKU_APP_NAME"].present?
should_enable_sentry = Rails.env.production? && heroku_environment && ENV["SENTRY_DSN"].present?

if should_enable_sentry
  Sentry.init do |config|
    config.dsn = ENV["SENTRY_DSN"]
    config.breadcrumbs_logger = [:active_support_logger, :http_logger]
    config.send_default_pii = true

    # Only report in production (Heroku) with a DSN present
    config.enabled_environments = %w[production]

    # performance sampling (light)
    config.traces_sample_rate = 0.1

    # disable profiling
    config.profiles_sample_rate = 0.0
  end
end
