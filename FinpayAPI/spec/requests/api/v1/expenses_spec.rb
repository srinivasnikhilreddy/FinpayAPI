require 'rails_helper'

RSpec.describe "Api::V1::Expenses", type: :request do
  let(:employee) { create(:user) }
  let(:admin)    { create(:user, :admin) }
  let(:category) { create(:category) }
  let!(:expense) { create(:expense, user: employee, category: category) }

  describe "GET /expenses" do
    it "returns expenses" do
      get "/api/v1/expenses", headers: auth_headers(employee)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /expenses/:id" do
    it "returns expense" do
      get "/api/v1/expenses/#{expense.id}", headers: auth_headers(employee)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /expenses" do
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

  describe "PATCH /expenses/:id" do
    it "updates expense" do
      patch "/api/v1/expenses/#{expense.id}",
            params: { expense: { description: "Updated" } },
            headers: auth_headers(employee),
            as: :json

      expect(response).to have_http_status(:ok)
      expect(expense.reload.description).to eq("Updated")
    end
  end

  describe "DELETE /expenses/:id" do
    it "soft deletes expense" do
      delete "/api/v1/expenses/#{expense.id}",
             headers: auth_headers(employee)

      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /expenses/:id/approve" do
    it "allows admin to approve" do
      patch "/api/v1/expenses/#{expense.id}/approve",
            headers: auth_headers(admin)

      expect(response).to have_http_status(:ok)
      expect(expense.reload).to be_approved
    end

    it "prevents employee from approving" do
      patch "/api/v1/expenses/#{expense.id}/approve",
            headers: auth_headers(employee)

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "PATCH /expenses/:id/reject" do
    it "allows admin to reject" do
      patch "/api/v1/expenses/#{expense.id}/reject",
            headers: auth_headers(admin)

      expect(response).to have_http_status(:ok)
      expect(expense.reload).to be_rejected
    end
  end
end