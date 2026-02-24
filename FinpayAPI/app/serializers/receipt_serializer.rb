class ReceiptSerializer
  include Alba::Resource

  attributes :id,
             :file_url,
             :amount,
             :expense_id,
             :created_at,
             :updated_at
end