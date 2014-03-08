workers Integer(ENV['PUMA_WORKERS'] || 2)
threads Integer(ENV['MIN_THREADS']  || 1), Integer(ENV['MAX_THREADS'] || 16)

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end

  Sidekiq.configure_client do |config|
    config.redis = { :size => 2 }
  end

  Sidekiq.configure_server do |config|
    # The config.redis is calculated by the
    # concurrency value so you do not need to
    # specify this. For this demo I do
    # show it to understand the numbers
    config.redis = { :size => 4 }
  end

  @sidekiq_pid ||= spawn("bundle exec sidekiq -c 2")
end