require 'rails_helper'

RSpec.describe ReminderEmailWorker, type: :worker do
  describe '#perform' do
    let!(:old_unconfirmed_user) { create(:user, created_at: 25.hours.ago, confirmation_sent_at: 25.hours.ago, confirmed_at: nil) }
    let!(:recent_unconfirmed_user) { create(:user, created_at: 23.hours.ago, confirmation_sent_at: 23.hours.ago, confirmed_at: nil) }
    let!(:confirmed_user) { create(:user, confirmed_at: 1.hour.ago) }

    it 'sends reminder emails to unconfirmed users older than 24 hours' do
      expect {
        ReminderEmailWorker.new.perform
      }.to change { ActionMailer::Base.deliveries.count }.by(1)

      old_unconfirmed_user.reload
      recent_unconfirmed_user.reload
      confirmed_user.reload

      expect(old_unconfirmed_user.confirmation_sent_at).to be > 24.hours.ago
      expect(recent_unconfirmed_user.confirmation_sent_at).to be < 24.hours.ago
      expect(confirmed_user.confirmation_sent_at).to be_nil
    end
  end
end