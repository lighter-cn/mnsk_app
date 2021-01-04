FactoryBot.define do
  factory :service do
    service_name   {Faker::String.random(length: 10..30)}
    service_status {'open'}
    price          {Faker::Number.between(from: 100, to: 100000)}
    explanation    {Faker::String.random(length: 30..300)}
    category_id    {Faker::Number.between(from: 2, to: 7)}

    association :user
  end
end
