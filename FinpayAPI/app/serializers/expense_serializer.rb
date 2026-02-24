class ExpenseSerializer
  # Serializer controls how your model is converted into a JSON when sending API response.
  # like DTOs in java spring boot
  include Alba::Resource

  attributes :id,
             :amount,
             :description,
             :status,
             :user_id,
             :category_id,
             :created_at,
             :updated_at

  one :user, serializer: UserSerializer
  one :category, serializer: CategorySerializer

  many :approvals, serializer: ApprovalSerializer
  many :receipts, serializer: ReceiptSerializer
end