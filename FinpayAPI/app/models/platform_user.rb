class PlatformUser < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :jwt_authenticatable,
         jwt_revocation_strategy: self

  include Devise::JWT::RevocationStrategies::JTIMatcher

  before_validation :set_default_role, on: :create

  enum role: {
    super_admin: "super_admin"
  }

  validates :email, presence: true, uniqueness: true
  validates :role, presence: true, inclusion: { in: roles.keys }

  def jwt_payload
    super.merge({
      'role' => role
    })
  end

  private

  def set_default_role
    self.role ||= "super_admin"
  end
end