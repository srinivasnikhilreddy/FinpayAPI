FactoryBot.define do
  factory :expense do
    amount { 100 }
    description { "Taxi" }
    status { "pending" }
    association :user
    association :category
  end
end