require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do
  describe "GET #new" do
    it "returns a success response" do
      get :new
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      let(:valid_attributes) {
        { email: "user@example.com", password: "Password1!", password_confirmation: "Password1!", first_name: "John", last_name: "Doe" }
      }

      it "creates a new User" do
        expect {
          post :create, params: { user: valid_attributes }
        }.to change(User, :count).by(1)
      end

      it "enqueues a confirmation email job" do
        expect {
          post :create, params: { user: valid_attributes }
        }.to change(EmailWorker.jobs, :size).by(1)
      end

      it "redirects to the root path" do
        post :create, params: { user: valid_attributes }
        expect(response).to redirect_to(root_path)
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) {
        { email: "", password: "password", password_confirmation: "different", first_name: "", last_name: "" }
      }

      it "does not create a new User" do
        expect {
          post :create, params: { user: invalid_attributes }
        }.to_not change(User, :count)
      end

      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { user: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end
end