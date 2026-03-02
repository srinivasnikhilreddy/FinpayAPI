require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  let(:admin)    { create(:user, :admin) }
  let(:employee) { create(:user) }

  describe "GET /users" do
    it "allows admin" do
      get "/api/v1/users", headers: auth_headers(admin)
      expect(response).to have_http_status(:ok)
    end

    it "forbids employee" do
      get "/api/v1/users", headers: auth_headers(employee)
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "GET /users/:id" do
    it "returns user" do
      get "/api/v1/users/#{employee.id}",
          headers: auth_headers(admin)

      expect(response).to have_http_status(:ok)
    end
  end
end