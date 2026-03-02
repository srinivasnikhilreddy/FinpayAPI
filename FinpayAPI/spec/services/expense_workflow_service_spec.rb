require 'rails_helper'

RSpec.describe ExpenseWorkflowService do
  let(:admin)   { create(:user, :admin) }
  let(:expense) { create(:expense) }
  let(:request) { double(remote_ip: "127.0.0.1", user_agent: "RSpec") }

  subject(:service) do
    described_class.new(expense: expense, actor: admin, request: request)
  end

  it 'approves expense and logs activity' do
    expect {
      service.approve!
    }.to change(ActivityLog, :count).by(1)

    expect(expense.reload).to be_approved
  end
end