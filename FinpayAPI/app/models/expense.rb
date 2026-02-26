class Expense < ApplicationRecord
  include SoftDeletable
  include Filterable

  belongs_to :user
  belongs_to :category

  has_many :approvals, dependent: :nullify
  has_many :receipts, dependent: :destroy

  enum status: { pending: 0, approved: 1, rejected: 2 }

  validates :amount,
            presence: true,
            numericality: { greater_than: 0 }

  validates :description,
            presence: true,
            length: { minimum: 3, maximum: 1000 }

  validates :status, presence: true

  def self.filterable_scopes
    %i[by_category by_status between_dates]
  end

  # Scopes: A scope in Rails is a reusable query definition that encapsulates common filtering logic at the model level.
  scope :for_user, ->(user) { where(user_id: user.id) }

  scope :by_category, ->(category_id) {
    where(category_id: category_id) if category_id.present?
  }

  scope :by_status, ->(status) {
    where(status: status) if status.present? && statuses.key?(status)
  }

  scope :between_dates, ->(from_date, to_date) {
    return unless from_date.present? && to_date.present?

    from = Date.parse(from_date) rescue nil
    to   = Date.parse(to_date) rescue nil

    where(created_at: from.beginning_of_day..to.end_of_day) if from && to
  }
end