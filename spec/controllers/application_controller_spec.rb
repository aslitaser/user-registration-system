require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      render plain: 'Hello World'
    end
  end

  describe "rate limiting" do
    it "limits requests" do
      allow(Rails.cache).to receive(:read).and_return(0, 1, 2, 3, 4, 5)
      allow(Rails.cache).to receive(:write)

      5.times do
        get :index
        expect(response).to have_http_status(:success)
      end

      get :index
      expect(response).to have_http_status(:too_many_requests)
    end
  end
end