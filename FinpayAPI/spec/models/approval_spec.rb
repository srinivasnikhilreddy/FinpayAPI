require 'rails_helper'

RSpec.describe Approval, type: :model do
  subject(:approval) { create(:approval) }

  let(:admin)    { create(:user, :admin) }
  let(:employee) { create(:user) }

  describe 'associations' do
    it { should belong_to(:expense) }
    it { should belong_to(:approver) }
  end

  describe 'AASM' do
    it { expect(approval).to be_pending }

    it 'allows admin to approve' do
      approval.approve!(admin)
      expect(approval).to be_approved
    end

    it 'prevents employee from approving' do
      expect { approval.approve!(employee) }
        .to raise_error(AASM::InvalidTransition)
    end
  end
end