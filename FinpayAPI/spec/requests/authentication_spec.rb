require 'rails_helper'

RSpec.describe "Authentication API", type: :request do
  let(:user) { create(:user, password: "Password@123") }

  describe "POST /login" do
    it "returns JWT token with valid credentials" do
      post "/login",
           params: {
             user: {
               email: user.email,
               password: "Password@123"
             }
           },
           as: :json

      expect(response).to have_http_status(:ok)
      expect(response.headers["Authorization"]).to be_present
    end

    it "returns unauthorized with invalid credentials" do
      post "/login",
           params: {
             user: {
               email: user.email,
               password: "WrongPassword"
             }
           },
           as: :json

      expect(response).to have_http_status(:unauthorized)
    end
  end
end