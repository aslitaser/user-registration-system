Rails.application.configure do
  config.lograge.enabled = true
  config.lograge.custom_options = lambda do |event|
    exceptions = %w(controller action format id)
    {
      time: Time.now.utc,
      user_id: event.payload[:user_id],
      params: event.payload[:params].except(*exceptions)
    }
  end
end