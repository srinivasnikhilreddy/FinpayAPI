RSpec.describe Expense, type: :model do
  it { should validate_presence_of(:amount) }
  it { should validate_numericality_of(:amount).is_greater_than(0) }
  it { should belong_to(:user) }
  it { should belong_to(:category) }
end

=begin
require 'rails_helper'

RSpec.describe Expense, type: :model do
  let(:user) { User.create!(name: "Test", email: "t@test.com", password: "Password@123", role: "employee") }
  let(:category) { Category.create!(name: "Travel") }

  it "is valid with valid attributes" do
    expense = Expense.new(
      amount: 100,
      description: "Taxi",
      status: "pending",
      user: user,
      category: category
    )
    expect(expense).to be_valid
  end

  it "is invalid without amount" do
    expense = Expense.new(amount: nil)
    expect(expense).not_to be_valid
  end
end
=end