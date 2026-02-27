module Api
  module V1
    class ApprovalListSerializer < BaseSerializer
      attributes :id,
                :status,
                :expense_id,
                :created_at
    end
  end
end