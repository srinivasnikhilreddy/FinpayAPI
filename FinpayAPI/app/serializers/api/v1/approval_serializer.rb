module Api
  module V1
    class ApprovalSerializer < BaseSerializer
      
      attributes :id,
             :status,
             :expense_id,
             :approver_id,
             :created_at,
             :updated_at

      one :approver, serializer: UserSerializer # one => one-to-one, many => one-to-many
    end
  end
end