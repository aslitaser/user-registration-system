require 'sidekiq'
require 'sidekiq-scheduler'
require 'bunny'

Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_URL'] || 'redis://localhost:6379/0' }

  config.on(:startup) do
    Sidekiq.schedule = YAML.load_file(File.expand_path('../../sidekiq.yml', __FILE__))[:scheduler][:schedule]
    SidekiqScheduler::Scheduler.instance.reload_schedule!
  end

  conn = Bunny.new(ENV['RABBITMQ_URL'] || 'amqp://localhost')
  conn.start
  ch = conn.create_channel
  queue = ch.queue('mailer', durable: true)

  config.on(:startup) do
    Thread.new do
      queue.subscribe(manual_ack: true, block: true) do |delivery_info, properties, body|
        payload = JSON.parse(body)
        EmailWorker.perform_async(payload['user_id'], payload['email_type'])
        ch.ack(delivery_info.delivery_tag)
      end
    end
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_URL'] || 'redis://localhost:6379/0' }
end