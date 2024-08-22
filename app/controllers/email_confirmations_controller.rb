class EmailConfirmationsController < ApplicationController
  def confirm
    user = User.find_by(confirmation_token: params[:token])
    if user
      user.update(confirmed_at: Time.current, confirmation_token: nil)
      redirect_to root_path, notice: 'Your email has been confirmed. You can now log in.'
    else
      redirect_to root_path, alert: 'Invalid confirmation token.'
    end
  end
end