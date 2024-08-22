class ApplicationController < ActionController::Base
  rescue_from StandardError, with: :internal_server_error
  before_action :check_rate_limit

  private

  def check_rate_limit
    key = "rate_limit:#{request.ip}"
    limit = 5
    period = 1.hour

    count = Rails.cache.read(key) || 0
    if count >= limit
      render json: { error: 'Rate limit exceeded' }, status: :too_many_requests
    else
      Rails.cache.write(key, count + 1, expires_in: period)
    end
  end

  def internal_server_error(exception)
    Rails.logger.error "Internal Server Error: #{exception}\n#{exception.backtrace.join("\n")}"
    render json: { error: 'Internal Server Error' }, status: :internal_server_error
  end
end