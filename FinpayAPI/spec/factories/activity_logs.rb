FactoryBot.define do
  factory :activity_log do
    association :user
    association :expense
    action { "approved" }
    metadata { { ip: "127.0.0.1" } }
  end
end
