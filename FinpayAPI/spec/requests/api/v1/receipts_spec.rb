require 'rails_helper'

RSpec.describe "Api::V1::Receipts", type: :request do
  let(:password) { "Password@123" }

  let!(:user) do
    User.create!(
      name: "Admin User",
      email: "admin@test.com",
      password: password,
      password_confirmation: password,
      role: "admin"
    )
  end

  let!(:category) { Category.create!(name: "Travel") }

  let!(:expense) do
    Expense.create!(
      amount: 100,
      description: "Taxi ride",
      status: "pending",
      user: user,
      category: category
    )
  end

  let!(:receipt) do
    Receipt.create!(
      expense: expense,
      file_url: "http://example.com/receipt.pdf",
      amount: 100
    )
  end

  # Login helper
  def auth_headers
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

  describe "GET /api/v1/expenses/:expense_id/receipts" do
    it "returns all receipts for an expense" do
      get "/api/v1/expenses/#{expense.id}/receipts",
          headers: auth_headers

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json).not_to be_empty
    end
  end

  describe "POST /api/v1/expenses/:expense_id/receipts" do
    it "creates a new receipt for an expense" do
      post "/api/v1/expenses/#{expense.id}/receipts",
           params: {
             receipt: {
               file_url: "http://example.com/new.pdf",
               amount: 100
             }
           },
           headers: auth_headers,
           as: :json

      expect(response).to have_http_status(:created)
    end
  end

  describe "GET /api/v1/receipts/:id" do
    it "returns a specific receipt" do
      get "/api/v1/receipts/#{receipt.id}",
          headers: auth_headers

      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /api/v1/receipts/:id" do
    it "updates a receipt" do
      patch "/api/v1/receipts/#{receipt.id}",
            params: {
              receipt: {
                file_url: "http://example.com/updated.pdf",
                amount: 150
              }
            },
            headers: auth_headers,
            as: :json

      expect(response).to have_http_status(:ok)
    end
  end

  describe "DELETE /api/v1/receipts/:id" do
    it "deletes a receipt" do
      delete "/api/v1/receipts/#{receipt.id}",
             headers: auth_headers

      expect(response).to have_http_status(:no_content)
    end
  end
end