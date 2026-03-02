class Approval < ApplicationRecord
  include SoftDeletable
  include AASM
  
  validate :approver_must_be_manager_or_admin

  belongs_to :expense
  belongs_to :approver, class_name: "User"

  validates :expense_id,
            presence: true,
            uniqueness: { scope: :approver_id, message: "can only be approved once per approver" }

  validates :approver_id, presence: true

  aasm column: :status do
    state :pending, initial: true
    state :approved
    state :rejected

    event :approve do
      transitions from: :pending,
                  to: :approved,
                  guard: :approver_allowed?
    end

    event :reject do
      transitions from: :pending,
                  to: :rejected,
                  guard: :approver_allowed?
    end
  end

  private

  def approver_must_be_manager_or_admin
    return if approver.blank? # let presence validation handle it
    return if approver.admin? || approver.manager?

    errors.add(:approver_id, "must be manager or admin")
  end

  def approver_allowed?(actor)
    return false unless actor
    actor.admin? || actor.manager?
  end
end