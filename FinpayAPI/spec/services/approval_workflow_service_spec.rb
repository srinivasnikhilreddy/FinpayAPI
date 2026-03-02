require 'rails_helper'

RSpec.describe ApprovalWorkflowService do
  let(:admin)    { create(:user, :admin) }
  let(:expense)  { create(:expense) }
  let(:approval) { create(:approval, expense: expense) }
  let(:request)  { double(remote_ip: "127.0.0.1") }

  subject(:service) do
    described_class.new(approval: approval, actor: admin, request: request)
  end

  it 'approves approval and logs activity' do
    expect {
      service.approve!
    }.to change(ActivityLog, :count).by(1)

    expect(approval.reload).to be_approved
  end
end