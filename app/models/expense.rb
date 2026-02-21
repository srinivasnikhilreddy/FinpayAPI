class Expense < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :approvals

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true

end
