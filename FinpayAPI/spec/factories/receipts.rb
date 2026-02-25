FactoryBot.define do
  factory :receipt do
    file_url { "http://example.com/receipt.pdf" }
    amount { 100 }
    association :expense
  end
end