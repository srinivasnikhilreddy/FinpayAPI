class Company < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :subdomain, presence: true,
                        uniqueness: true,
                        format: { with: /\A[a-z0-9_]+\z/, message: "only lowercase letters, numbers and underscores allowed" },
                        length: { minimum: 3, maximum: 63 }
  validate :subdomain_not_reserved

  private

  def subdomain_not_reserved
    reserved = %w[public admin api platform www]
    if reserved.include?(subdomain)
      errors.add(:subdomain, "is reserved")
    end
  end
end
