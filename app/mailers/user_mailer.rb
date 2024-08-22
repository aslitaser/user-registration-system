class UserMailer < ApplicationMailer
  def confirmation_email(user)
    @user = user
    @confirmation_url = confirm_email_url(token: @user.confirmation_token)
    mail(to: @user.email, subject: "Confirm your account")
  end
  def reminder_email(user)
    @user = user
    mail(to: @user.email, subject: "Reminder: Please confirm your account")
  end
end
