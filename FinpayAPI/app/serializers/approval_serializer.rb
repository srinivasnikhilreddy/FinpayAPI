class ApprovalSerializer
  include Alba::Resource

  attributes :id,
             :status,
             :expense_id,
             :approver_id,
             :created_at,
             :updated_at

  one :approver, serializer: UserSerializer
end