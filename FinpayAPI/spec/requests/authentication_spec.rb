require 'rails_helper'

RSpec.describe "Authentication API", type: :request do
  let(:valid_password) { "Password@123" }

  let!(:user) do
    User.create!(
      name: "Test User",
      email: "test@example.com",
      password: valid_password,
      password_confirmation: valid_password,
      role: "employee"
    )
  end

  describe "POST /register" do
    context "with valid parameters" do
      it "registers a new user successfully" do
        post "/register", params: {
          user: {
            name: "New User",
            email: "new@example.com",
            password: valid_password,
            password_confirmation: valid_password
          }
        }, as: :json

        expect(response).to have_http_status(:created)

        json = JSON.parse(response.body)
        expect(json["status"]["message"]).to eq("Signed up successfully.")
      end
    end

    context "with invalid parameters" do
      it "returns validation errors" do
        post "/register", params: {
          user: {
            name: "",
            email: "",
            password: "123",
            password_confirmation: "456"
          }
        }, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "POST /login" do
    context "with correct credentials" do
      it "logs in successfully and returns JWT token" do
        post "/login", params: {
          user: {
            email: user.email,
            password: valid_password
          }
        }, as: :json

        expect(response).to have_http_status(:ok)

        # JWT token should be present in Authorization header
        expect(response.headers["Authorization"]).to be_present
      end
    end

    context "with incorrect credentials" do
      it "returns unauthorized" do
        post "/login", params: {
          user: {
            email: user.email,
            password: "WrongPassword"
          }
        }, as: :json

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /logout" do
    it "logs out successfully" do
      post "/login", params: {
        user: {
          email: user.email,
          password: valid_password
        }
      }, as: :json

      token = response.headers["Authorization"]

      delete "/logout",
            headers: { "HTTP_AUTHORIZATION" => token },
            as: :json

      puts "STATUS: #{response.status}"
      puts "BODY: #{response.body}"

      expect(response).to have_http_status(:ok)
    end
  end

  describe "Access protected route" do
    it "returns unauthorized without token" do
      get "/api/v1/users"

      expect(response).to have_http_status(:unauthorized)
    end

    it "allows access with valid token" do
      post "/login", params: {
        user: {
          email: user.email,
          password: valid_password
        }
      }, as: :json

      token = response.headers["Authorization"]

      get "/api/v1/users", headers: {
        "Authorization" => token
      }

      expect(response).not_to have_http_status(:unauthorized)
    end
  end
end