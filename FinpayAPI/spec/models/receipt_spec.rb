require 'rails_helper'

RSpec.describe Receipt, type: :model do
  let(:user) { User.create!(name: "Test", email: "u@test.com", password: "Password@123", role: "employee") }
  let(:category) { Category.create!(name: "Travel") }
  let(:expense) do
    Expense.create!(
      amount: 200,
      description: "Hotel",
      status: "pending",
      user: user,
      category: category
    )
  end

  it "is valid with valid attributes" do
    receipt = Receipt.new(
      file_url: "http://example.com/receipt.pdf",
      amount: 200,
      expense: expense
    )
    expect(receipt).to be_valid
  end

  it "is invalid without file_url" do
    receipt = Receipt.new(amount: 200, expense: expense)
    expect(receipt).not_to be_valid
  end
end