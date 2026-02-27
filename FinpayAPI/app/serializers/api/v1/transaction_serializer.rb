module Api
  module V1
    class TransactionSerializer < BaseSerializer
      attributes :id,
                :amount,
                :transaction_type,
                :status,
                :account_id,
                :created_at,
                :updated_at

      one :account, serializer: AccountSerializer
    end
  end
end