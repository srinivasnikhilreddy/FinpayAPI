class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :jwt_authenticatable,
         jwt_revocation_strategy: self

  enum role: { employee: 'employee', manager: 'manager', admin: 'admin' }

  has_many :expenses
  has_many :approvals, foreign_key: :approver_id
  
  validates :email, presence: true, uniqueness: true

  # Generate JWT identifier before creating user
  before_create :generate_jti

  def self.jwt_revoked?(payload, user)
    user.jti != payload['jti']
  end

  def self.revoke_jwt(payload, user)
    user.update!(jti: SecureRandom.uuid)
  end

  private

  def generate_jti
    self.jti ||= SecureRandom.uuid
  end
end