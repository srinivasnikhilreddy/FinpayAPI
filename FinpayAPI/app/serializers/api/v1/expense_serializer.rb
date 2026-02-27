module Api
  module V1
    class ExpenseSerializer < BaseSerializer

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
  end
end