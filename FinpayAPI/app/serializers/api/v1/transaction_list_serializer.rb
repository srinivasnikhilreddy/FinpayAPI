module Api    
  module V1
    class TransactionListSerializer < BaseSerializer
      attributes :id,
                 :amount,
                 :transaction_type,
                 :status,
                 :created_at
    end
  end
end