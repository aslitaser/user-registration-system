class EmailWorker
  include Sidekiq::Worker

  def perform(user_id, email_type)
    user = User.find(user_id)
    case email_type
    when 'confirmation'
      UserMailer.confirmation_email(user).deliver_now
    end
  end
end