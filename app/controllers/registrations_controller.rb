class RegistrationsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      EmailWorker.perform_async(@user.id, 'confirmation')
      redirect_to root_path, notice: 'Please check your email to confirm your account.'
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name)
  end

  def enqueue_confirmation_email
    conn = Bunny.new(ENV['RABBITMQ_URL'] || 'amqp://localhost')
    conn.start
    ch = conn.create_channel
    queue = ch.queue('mailer', durable: true)
    queue.publish(
      { user_id: @user.id, email_type: 'confirmation' }.to_json,
      persistent: true,
      content_type: 'application/json'
    )
    conn.close
  end
end