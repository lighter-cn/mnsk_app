FactoryBot.define do
  factory :card do
    card_token {Faker::Internet.password(min_length: 20)}
    customer_token {Faker::Internet.password(min_length: 20)}
    association :user
  end
end
