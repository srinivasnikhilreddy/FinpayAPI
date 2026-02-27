require 'rails_helper'

RSpec.describe "Api::V1::Receipts", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:expense) { create(:expense, user: admin) }
  let!(:receipt) { create(:receipt, expense: expense) }

  describe "GET /api/v1/expenses/:expense_id/receipts" do
    it "returns receipts" do
      get "/api/v1/expenses/#{expense.id}/receipts",
          headers: auth_headers(admin)

      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /api/v1/expenses/:expense_id/receipts" do
    it "creates receipt" do
      post "/api/v1/expenses/#{expense.id}/receipts",
           params: {
             receipt: {
               file_url: "http://example.com/new.pdf",
               amount: 100
             }
           },
           headers: auth_headers(admin),
           as: :json

      expect(response).to have_http_status(:created)
    end
  end
end