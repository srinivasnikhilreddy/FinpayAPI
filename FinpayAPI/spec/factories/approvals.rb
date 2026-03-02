FactoryBot.define do
  factory :approval do
    association :expense
    association :approver, factory: :user, role: "manager"
  end
end