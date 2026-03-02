require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }

  it { should have_many(:expenses) }
  it { should have_many(:approvals).with_foreign_key(:approver_id) }
end