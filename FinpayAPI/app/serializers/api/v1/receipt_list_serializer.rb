module Api
  module V1
    class ReceiptListSerializer < BaseSerializer

      attributes :id,
                :file_url,
                :amount,
                :expense_id,
                :created_at
    end    
  end
end
