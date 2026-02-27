module Api
  module V1
    class ExpenseListSerializer < BaseSerializer
      attributes :id,
                 :amount,
                 :description,
                 :status,
                 :created_at

      one :category, serializer: CategorySerializer
    end
  end
end