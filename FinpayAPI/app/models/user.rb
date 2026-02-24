class User < ApplicationRecord
  has_many :expenses
  has_many :approvals, foreign_key: :approver_id
  belongs_to :company

  validates :email, presence: true, uniqueness: true

end
