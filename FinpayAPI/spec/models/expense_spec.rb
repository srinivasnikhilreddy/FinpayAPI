require 'rails_helper'

RSpec.describe Expense, type: :model do
  subject(:expense) { create(:expense) }

  let(:admin)    { create(:user, :admin) }
  let(:manager)  { create(:user, :manager) }
  let(:employee) { create(:user) }

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:category) }
    it { should have_many(:approvals) }
    it { should have_many(:activity_logs) }
  end

  describe 'validations' do
    it { should validate_presence_of(:amount) }
    it { should validate_numericality_of(:amount).is_greater_than(0) }
    it { should validate_presence_of(:description) }
  end

  describe 'AASM' do
    it { expect(expense).to be_pending }

    it 'allows admin to approve' do
      expense.approve!(admin)
      expect(expense).to be_approved
    end

    it 'prevents employee from approving' do
      expect { expense.approve!(employee) }
        .to raise_error(AASM::InvalidTransition)
    end

    it 'transitions approved → reimbursed' do
      expense.approve!(admin)
      expense.mark_reimbursed!
      expect(expense).to be_reimbursed
    end

    it 'transitions rejected → archived' do
      expense.reject!(admin)
      expense.archive!
      expect(expense).to be_archived
    end
  end
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