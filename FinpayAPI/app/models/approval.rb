class Approval < ApplicationRecord
  include SoftDeletable
  
  belongs_to :expense
  belongs_to :approver, class_name: "User"

  validates :status,
            presence: true,
            inclusion: { in: %w[pending approved rejected] }

  validates :expense_id,
            presence: true,
            uniqueness: { scope: :approver_id, message: "can only be approved once per approver" }

  validates :approver_id, presence: true

  # In Rails, a scope is just a reusable query.
  scope :pending,  -> { where(status: 'pending') } # where(status: "pending")
  scope :approved, -> { where(status: 'approved') }
  scope :rejected, -> { where(status: 'rejected') }

  after_create :sync_expense_status
  after_update :sync_expense_status, if: :saved_change_to_status?

  private

  def sync_expense_status
    statuses = expense.approvals.pluck(:status)

    new_status =
      if statuses.include?("rejected")
        "rejected"
      elsif statuses.include?("pending")
        "pending"
      else
        "approved"
      end

    expense.update!(status: new_status) if expense.status != new_status
  end
end