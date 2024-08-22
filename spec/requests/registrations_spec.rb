require 'rails_helper'

RSpec.describe "Registrations", type: :request do
  describe "GET /signup" do
    it "returns http success" do
      get signup_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /signup" do
    let(:valid_attributes) {
      { email: "user@example.com", password: "Password1!", password_confirmation: "Password1!", first_name: "John", last_name: "Doe" }
    }

    it "creates a new user" do
      expect {
        post signup_path, params: { user: valid_attributes }
      }.to change(User, :count).by(1)
    end

    it "redirects to the root path" do
      post signup_path, params: { user: valid_attributes }
      expect(response).to redirect_to(root_path)
    end
  end
end