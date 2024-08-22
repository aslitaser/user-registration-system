require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with valid attributes" do
    user = build(:user)
    expect(user).to be_valid
  end
  it "is not valid without an email" do
    user = User.new(email: nil)
    expect(user).to_not be_valid
  end

  it "is not valid with an invalid email format" do
    user = User.new(email: "invalid_email")
    expect(user).to_not be_valid
  end

  it "is not valid without a password" do
    user = User.new(password: nil)
    expect(user).to_not be_valid
  end

  it "is not valid with a short password" do
    user = User.new(password: "short")
    expect(user).to_not be_valid
  end

  it "generates a confirmation token before creation" do
    user = create(:user)
    expect(user.confirmation_token).to_not be_nil
    expect(user.confirmation_sent_at).to_not be_nil
  end

  describe 'caching' do
    let(:user) { create(:user) }

    it 'caches user profile' do
      expect(Rails.cache).to receive(:fetch).with([user, "profile"], expires_in: 12.hours)
      user.cached_profile
    end

    it 'caches user lookup' do
      expect(Rails.cache).to receive(:fetch).with(["user", user.id], expires_in: 1.hour)
      User.find_cached(user.id)
    end
  end

  describe 'password validation' do
    it 'requires complex passwords' do
      user = build(:user, password: 'simple')
      expect(user).to be_invalid
      expect(user.errors[:password]).to include('Complexity requirement not met. Please use: 1 uppercase, 1 lowercase, 1 digit, 1 special character and 8+ characters')
    end
  end
end
