if ENV["REDISCLOUD_URL"]
  require "redis"

  $redis = Redis.new(url: ENV["REDISCLOUD_URL"])

  # Test konekcije
  begin
    $redis.ping
    Rails.logger.info "Connected to Redis"
  rescue StandardError => e
    Rails.logger.error "Redis connection failed: #{e.message}"
  end
else
  Rails.logger.warn "REDISCLOUD_URL not set, Redis not configured."
end
