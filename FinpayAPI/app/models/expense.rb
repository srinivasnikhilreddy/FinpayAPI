class Expense < ApplicationRecord
  include SoftDeletable

  # Associations
  belongs_to :user
  belongs_to :category

  has_many :approvals, dependent: :nullify
  has_many :receipts, dependent: :destroy

  # Validations
  validates :amount,
            presence: true,
            numericality: { greater_than: 0 }

  validates :description,
            presence: true,
            length: { minimum: 3, maximum: 1000 }

  validates :status,
            presence: true,
            inclusion: { in: %w[pending approved rejected] }

  # Scopes: A scope in Rails is a reusable query definition that encapsulates common filtering logic at the model level.
  scope :pending,  -> { where(status: 'pending') } # We call Expenses.pending, instead of Expenses.where(status: 'pending')
  scope :approved, -> { where(status: 'approved') }
  scope :rejected, -> { where(status: 'rejected') }
  scope :for_user, ->(user) { where(user_id: user.id) }
end