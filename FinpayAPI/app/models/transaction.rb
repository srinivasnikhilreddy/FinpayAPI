class Transaction < ApplicationRecord
  include SoftDeletable
  
  belongs_to :account # (child) each transaction belongs to one account

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :transaction_type, presence: true, inclusion: { in: %w(debit credit) }
  validates :status, presence: true, inclusion: { in: %w(pending completed failed) }
  validates :account_id, presence: true

  scope :debits, -> { where(transaction_type: 'debit') } # Transaction.debits => SELECT * FROM transactions WHERE transaction_type = 'debit';
  scope :credits, -> { where(transaction_type: 'credit') }
  scope :completed, -> { where(status: 'completed') }
end