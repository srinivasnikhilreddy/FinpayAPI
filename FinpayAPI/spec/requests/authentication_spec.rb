require 'rails_helper'

RSpec.describe "Authentication API", type: :request do
  let(:user) { create(:user) }

  describe "POST /login" do
    it "returns JWT token" do
      post "/login", params: {
        user: {
          email: user.email,
          password: "Password@123"
        }
      }, as: :json

      expect(response).to have_http_status(:ok)
      expect(response.headers["Authorization"]).to be_present
    end
  end

  describe "GET protected route" do
    it "returns unauthorized without token" do
      get "/api/v1/users"
      expect(response).to have_http_status(:unauthorized)
    end

    it "allows access with token" do
      get "/api/v1/users", headers: auth_headers(user)
      expect(response).not_to have_http_status(:unauthorized)
    end
  end
end