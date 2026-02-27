module Api
  module V1
    class AccountSerializer < BaseSerializer

      attributes :id,
                :name,
                :balance,
                :created_at,
                :updated_at
    end
  end
end
