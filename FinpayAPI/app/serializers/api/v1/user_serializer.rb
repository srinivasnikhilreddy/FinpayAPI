module Api
  module V1
    class UserSerializer < BaseSerializer

      attributes :id,
                :name,
                :email,
                :role,
                :created_at,
                :updated_at
    end
  end
end