class User < ApplicationRecord
  # Associations
  has_many :accounts, dependent: :destroy # delete on cascade
  has_many :expenses, dependent: :destroy
  has_many :approvals, foreign_key: :approver_id, dependent: :nullify # nullify on cascade

  # Devise
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :jwt_authenticatable,
         jwt_revocation_strategy: self

  # Revocation Strategies? jwt will have a expiration date, after that it will become useless. but before that if user logsout and the token will be still valid.
  # The bearer of the token has access granted to it and no further authentication is needed. it somehow falls into the wrong hands, someone could access protected content and tamper with things.
  include Devise::JWT::RevocationStrategies::JTIMatcher

  # Enum
  enum role: {
    employee: "employee",
    manager: "manager",
    admin: "admin"
  }

  # Validations
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :role, presence: true, inclusion: { in: roles.keys }

  # JWT custom payload
  def jwt_payload
    super.merge({
      'name' => name,
      'role' => role
    })
  end
=begin
{
  "sub": user_id,
  "jti": "...",
  "exp": 12345678,
  "name": "Srinivas",
  "role": "admin"
}
=end
end