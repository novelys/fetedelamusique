worker_processes 3
timeout 30
preload_app true

before_fork do |server, worker|
  # If you are using Redis but not Resque, change this
  if defined?(Resque)
    Resque.redis.quit
    Rails.logger.info('Disconnected from Redis')
  end

  sleep 1
end

after_fork do |server, worker|
  # If you are using Redis but not Resque, change this
  if defined?(Resque)
    ENV["REDISTOGO_URL"] ||= "redis://localhost:6379/"
    uri = URI.parse(ENV["REDISTOGO_URL"])
    Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password, :thread_safe => true)
    Rails.logger.info('Connected to Redis')
  end
end