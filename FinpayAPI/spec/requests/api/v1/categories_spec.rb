require 'rails_helper'

RSpec.describe "Api::V1::Categories", type: :request do
  let(:password) { "Password@123" }

  let!(:admin) do
    User.create!(
      name: "Admin",
      email: "admin@test.com",
      password: password,
      password_confirmation: password,
      role: "admin"
    )
  end

  let!(:employee) do
    User.create!(
      name: "Employee",
      email: "employee@test.com",
      password: password,
      password_confirmation: password,
      role: "employee"
    )
  end

  def login(user)
    post "/login", params: {
      user: {
        email: user.email,
        password: password
      }
    }, as: :json

    {
      "Authorization" => response.headers["Authorization"]
    }
  end

  describe "GET /api/v1/categories" do
    before { Category.create!(name: "Travel") }

    it "returns categories for authenticated user" do
      get "/api/v1/categories", headers: login(admin)

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).not_to be_empty
    end
  end

  describe "POST /api/v1/categories" do
    context "as admin" do
      it "creates category successfully" do
        expect {
          post "/api/v1/categories",
               params: { category: { name: "Food" } },
               headers: login(admin),
               as: :json
        }.to change(Category, :count).by(1)

        expect(response).to have_http_status(:created)
      end
    end

    context "as employee" do
      it "returns forbidden" do
        post "/api/v1/categories",
             params: { category: { name: "Office" } },
             headers: login(employee),
             as: :json

        expect(response).to have_http_status(:forbidden)
      end
    end

    context "with invalid params" do
      it "returns validation error" do
        post "/api/v1/categories",
             params: { category: { name: "" } },
             headers: login(admin),
             as: :json

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end