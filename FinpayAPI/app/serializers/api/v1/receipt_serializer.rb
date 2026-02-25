module Api
  module V1
    class ReceiptSerializer < BaseSerializer

      attributes :id,
                :file_url,
                :amount,
                :expense_id,
                :created_at,
                :updated_at
    end    
  end
end
