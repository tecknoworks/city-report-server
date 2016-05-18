redis_url = APP_CONFIG['redis']['url']
throw 'redis not configured' unless redis_url

Sidekiq.configure_server do |config|
  config.redis = { url: redis_url }
end

Sidekiq.configure_client do |config|
  config.redis = { url: redis_url }
end
