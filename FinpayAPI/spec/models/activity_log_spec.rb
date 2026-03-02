require 'rails_helper'

RSpec.describe ActivityLog, type: :model do
  subject { build(:activity_log) }

  it { should belong_to(:user) }
  it { should belong_to(:expense) }
  it { should validate_presence_of(:action) }
end