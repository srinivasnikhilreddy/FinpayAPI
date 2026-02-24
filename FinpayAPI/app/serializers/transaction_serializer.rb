class TransactionSerializer
  include Alba::Resource

  attributes :id,
             :amount,
             :transaction_type,
             :status,
             :account_id,
             :created_at,
             :updated_at

  one :account, serializer: AccountSerializer
end