class AuditLog < ApplicationRecord
  belongs_to :user, optional: true

  validates :action, presence: true
  validates :resource_type, presence: true

  scope :recent, -> { order(created_at: :desc) }
  scope :for_resource, ->(type, id) { where(resource_type: type, resource_id: id) }
end