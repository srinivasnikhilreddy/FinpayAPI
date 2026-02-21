class Approval < ApplicationRecord
  belongs_to :expense
  belongs_to :approver, class_name: "User"
end
