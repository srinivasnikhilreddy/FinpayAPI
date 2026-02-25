FactoryBot.define do
  factory :user do
    name { "Test User" }
    sequence(:email) { |n| "user#{n}@test.com" }
    password { "Password@123" }
    password_confirmation { "Password@123" }
    role { "employee" }

    trait :admin do
      role { "admin" }
    end

    trait :manager do
      role { "manager" }
    end
  end
end