module Api
  module V1
    class UserListSerializer < BaseSerializer

      attributes :id,
                :name,
                :email,
                :role,
                :created_at
    end
  end
end