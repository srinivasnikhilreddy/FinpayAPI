class Expense < ApplicationRecord
  include SoftDeletable
  include Filterable
  include AASM

  belongs_to :user
  belongs_to :category

  has_many :approvals, dependent: :nullify
  has_many :receipts, dependent: :destroy
  has_many :activity_logs, dependent: :destroy

  # enum status: { pending: 0, approved: 1, rejected: 2 }

  validates :amount,
            presence: true,
            numericality: { greater_than: 0 }

  validates :description,
            presence: true,
            length: { minimum: 3, maximum: 1000 }

  # validates :status, presence: true

  aasm column: :status do
    state :pending, initial: true
    state :approved
    state :rejected
    state :reimbursed
    state :archived

    event :approve do
      transitions from: :pending, to: :approved, guard: :manager_or_admin?
    end

    event :reject do
      transitions from: :pending, to: :rejected, guard: :manager_or_admin?
    end

    event :mark_reimbursed do
      transitions from: :approved, to: :reimbursed
    end

    event :archive do
      transitions from: [:rejected, :reimbursed], to: :archived
    end
  end
  
  # Scopes: A scope in Rails is a reusable query definition that encapsulates common filtering logic at the model level.
  scope :for_user, ->(user) { where(user_id: user.id) }

  scope :by_category, ->(category_id) {
    where(category_id: category_id) if category_id.present?
  }

  scope :by_status, ->(status) {
    where(status: status) if status.present?
  }

  scope :between_dates, ->(from_date, to_date) {
    return unless from_date.present? && to_date.present?

    from = Date.parse(from_date) rescue nil
    to   = Date.parse(to_date) rescue nil

    where(created_at: from.beginning_of_day..to.end_of_day) if from && to
  }

  def self.filterable_scopes
    %i[by_category by_status between_dates]
  end

  private

  def manager_or_admin?(actor)
    return false if actor.id == user_id
    actor.admin? || actor.manager?
  end
  
end