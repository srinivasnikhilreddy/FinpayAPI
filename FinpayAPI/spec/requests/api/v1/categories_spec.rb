require 'rails_helper'

RSpec.describe "Api::V1::Categories", type: :request do
  let(:admin)    { create(:user, :admin) }
  let(:employee) { create(:user) }
  let!(:category){ create(:category) }

  describe "GET /categories" do
    it "returns categories for authenticated user" do
      get "/api/v1/categories", headers: auth_headers(employee)

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["data"]).to be_present
    end

    it "returns unauthorized without token" do
      get "/api/v1/categories"
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "GET /categories/:id" do
    it "returns category" do
      get "/api/v1/categories/#{category.id}", headers: auth_headers(admin)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /categories" do
    it "allows admin to create" do
      expect {
        post "/api/v1/categories",
             params: { category: { name: "Food" } },
             headers: auth_headers(admin),
             as: :json
      }.to change(Category, :count).by(1)

      expect(response).to have_http_status(:created)
    end

    it "prevents employee from creating" do
      post "/api/v1/categories",
           params: { category: { name: "Office" } },
           headers: auth_headers(employee),
           as: :json

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "PATCH /categories/:id" do
    it "allows admin to update" do
      patch "/api/v1/categories/#{category.id}",
            params: { category: { name: "Updated" } },
            headers: auth_headers(admin),
            as: :json

      expect(response).to have_http_status(:ok)
      expect(category.reload.name).to eq("Updated")
    end
  end

  describe "DELETE /categories/:id" do
    it "allows admin to delete" do
      expect {
        delete "/api/v1/categories/#{category.id}",
               headers: auth_headers(admin)
      }.to change(Category, :count).by(-1)

      expect(response).to have_http_status(:ok)
    end
  end
end