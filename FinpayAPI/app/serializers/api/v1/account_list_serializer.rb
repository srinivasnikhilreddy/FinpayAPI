module Api
  module V1
    class AccountListSerializer < BaseSerializer

      attributes :id,
                :name,
                :balance,
                :created_at
    end
  end
end
