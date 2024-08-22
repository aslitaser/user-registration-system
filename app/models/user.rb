class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 8 }, if: -> { new_record? || !password.nil? }
  validates :first_name, presence: true
  validates :last_name, presence: true
  validate :password_complexity

  before_create :generate_confirmation_token

  def cached_profile
    Rails.cache.fetch([self, "profile"], expires_in: 12.hours) do
      {
        id: id,
        email: email,
        full_name: "#{first_name} #{last_name}",
        confirmed: confirmed_at.present?
      }
    end
  end

  def self.find_cached(id)
    Rails.cache.fetch(["user", id], expires_in: 1.hour) do
      find(id)
    end
  end

  private

  def password_complexity
    return if password.blank? || password =~ /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,70}$/
    errors.add :password, "Complexity requirement not met. Please use: 1 uppercase, 1 lowercase, 1 digit, 1 special character and 8+ characters"
  end

  def generate_confirmation_token
    self.confirmation_token = SecureRandom.urlsafe_base64
    self.confirmation_sent_at = Time.current
  end
end