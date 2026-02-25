require 'rails_helper'

RSpec.describe "Api::V1::Categories", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:employee) { create(:user) }

  describe "GET /api/v1/categories" do
    before { create(:category) }

    it "returns categories for authenticated user" do
      get "/api/v1/categories", headers: auth_headers(admin)

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["data"]).to be_present
    end
  end

  describe "POST /api/v1/categories" do
    context "as admin" do
      it "creates category" do
        expect {
          post "/api/v1/categories",
               params: { category: { name: "Food" } },
               headers: auth_headers(admin),
               as: :json
        }.to change(Category, :count).by(1)

        expect(response).to have_http_status(:created)
      end
    end

    context "as employee" do
      it "returns forbidden" do
        post "/api/v1/categories",
             params: { category: { name: "Office" } },
             headers: auth_headers(employee),
             as: :json

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end