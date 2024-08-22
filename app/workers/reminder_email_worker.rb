class ReminderEmailWorker
  include Sidekiq::Worker

  def perform
    users_to_remind = User.where(confirmed_at: nil)
                          .where('created_at < ?', 24.hours.ago)
                          .where('confirmation_sent_at < ?', 24.hours.ago)

    users_to_remind.each do |user|
      UserMailer.reminder_email(user).deliver_now
      user.update(confirmation_sent_at: Time.current)
    end
  end
end
