require 'rails_helper'

RSpec.describe "Api::V1::Approvals", type: :request do
  let(:admin)    { create(:user, :admin) }
  let(:manager)  { create(:user, :manager) }
  let(:employee) { create(:user) }
  let(:expense)  { create(:expense) }
  let!(:approval){ create(:approval, expense: expense, approver: manager) }

  describe "GET /approvals" do
    it "allows manager" do
      get "/api/v1/approvals", headers: auth_headers(manager)
      expect(response).to have_http_status(:ok)
    end

    it "forbids employee" do
      get "/api/v1/approvals", headers: auth_headers(employee)
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "GET /approvals/:id" do
    it "returns approval" do
      get "/api/v1/approvals/#{approval.id}",
          headers: auth_headers(manager)

      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /approvals" do
    let(:new_manager) { create(:user, :manager) }

    it "creates approval" do
      expect {
        post "/api/v1/approvals",
            params: { approval: { expense_id: expense.id, approver_id: new_manager.id } },
            headers: auth_headers(admin),
            as: :json
      }.to change(Approval, :count).by(1)

      expect(response).to have_http_status(:created)
    end
  end

  describe "PATCH /approvals/:id" do
    it "updates approval" do
      patch "/api/v1/approvals/#{approval.id}",
            params: { approval: { approver_id: admin.id } },
            headers: auth_headers(admin),
            as: :json

      expect(response).to have_http_status(:ok)
    end
  end

  describe "DELETE /approvals/:id" do
    it "deletes approval" do
      expect {
        delete "/api/v1/approvals/#{approval.id}",
               headers: auth_headers(admin)
      }.to change(Approval, :count).by(-1)

      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /approvals/:id/approve" do
    it "allows manager to approve" do
      patch "/api/v1/approvals/#{approval.id}/approve",
            headers: auth_headers(manager)

      expect(response).to have_http_status(:ok)
      expect(approval.reload).to be_approved
    end
  end

  describe "PATCH /approvals/:id/reject" do
    it "allows manager to reject" do
      patch "/api/v1/approvals/#{approval.id}/reject",
            headers: auth_headers(manager)

      expect(response).to have_http_status(:ok)
      expect(approval.reload).to be_rejected
    end
  end
end