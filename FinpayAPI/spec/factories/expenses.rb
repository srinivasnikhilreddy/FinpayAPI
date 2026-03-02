FactoryBot.define do
  factory :expense do
    amount { 100 }
    description { "Taxi ride" }
    association :user
    association :category
  end
end