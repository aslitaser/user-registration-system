FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "Password123!" }
    first_name { "John" }
    last_name { "Doe" }
    confirmation_token { SecureRandom.urlsafe_base64 }
    confirmation_sent_at { Time.current }
  end
end