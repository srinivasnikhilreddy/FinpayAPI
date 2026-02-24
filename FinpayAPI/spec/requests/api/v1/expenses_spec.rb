require 'rails_helper'

RSpec.describe "Api::V1::Expenses", type: :request do
  let(:password) { "Password@123" }

  let!(:employee) do
    User.create!(
      name: "Employee",
      email: "employee@test.com",
      password: password,
      password_confirmation: password,
      role: "employee"
    )
  end

  let!(:admin) do
    User.create!(
      name: "Admin",
      email: "admin2@test.com",
      password: password,
      password_confirmation: password,
      role: "admin"
    )
  end

  let!(:category) { Category.create!(name: "Travel") }

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

  describe "GET /api/v1/expenses" do
    before do
      Expense.create!(
        amount: 100,
        description: "Taxi",
        status: "pending",
        user: employee,
        category: category
      )
    end

    it "returns expenses for authenticated user" do
      get "/api/v1/expenses", headers: login(employee)

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).not_to be_empty
    end
  end

  describe "POST /api/v1/expenses" do
    context "with valid params" do
      it "creates expense successfully" do
        expect {
          post "/api/v1/expenses",
               params: {
                 expense: {
                   amount: 200,
                   description: "Hotel",
                   category_id: category.id
                 }
               },
               headers: login(employee),
               as: :json
        }.to change(Expense, :count).by(1)

        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid params" do
      it "returns validation error" do
        post "/api/v1/expenses",
             params: {
               expense: {
                 amount: 0,
                 description: "",
                 category_id: category.id
               }
             },
             headers: login(employee),
             as: :json

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end