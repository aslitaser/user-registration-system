require 'rails_helper'

RSpec.describe EmailWorker, type: :worker do
  describe '#perform' do
    let(:user) { create(:user) }

    it 'sends a confirmation email' do
      expect {
        EmailWorker.new.perform(user.id, 'confirmation')
      }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end