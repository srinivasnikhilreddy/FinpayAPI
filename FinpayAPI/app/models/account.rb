class Account < ApplicationRecord
  include SoftDeletable
  
  belongs_to :user
  has_many :transactions # (parent) one Account many transactions
  # has_many :transactions, dependent: :destroy -> If the parent (Account) is deleted, automatically delete all associated transactions.

  validates :name, presence: true, uniqueness: true
  validates :balance, presence: true, numericality: { greater_than_or_equal_to: 0 }

  before_validation :normalize_balance

  scope :active, -> { where(deleted_at: nil) }

  def deposit(amount)
    update!(balance: balance + BigDecimal(amount.to_s))
  end

  def withdraw(amount)
    raise StandardError, I18n.t("transactions.insufficient_funds") if balance < amount
    update!(balance: balance - BigDecimal(amount.to_s))
  end

  private

  def normalize_balance
    self.balance = BigDecimal(balance.to_s || "0")
  end
end