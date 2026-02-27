require 'rails_helper'

RSpec.describe "Api::V1::Expenses", type: :request do
  let(:employee) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:category) { create(:category) }

  describe "GET /api/v1/expenses" do
    before { create(:expense, user: employee, category: category) }

    it "returns expenses" do
      get "/api/v1/expenses", headers: auth_headers(employee)

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["data"]).to be_present
    end
  end

  describe "POST /api/v1/expenses" do
    it "creates expense" do
      expect {
        post "/api/v1/expenses",
             params: {
               expense: {
                 amount: 200,
                 description: "Hotel",
                 category_id: category.id
               }
             },
             headers: auth_headers(employee),
             as: :json
      }.to change(Expense, :count).by(1)

      expect(response).to have_http_status(:created)
    end
  end
end