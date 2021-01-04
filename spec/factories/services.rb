FactoryBot.define do
  factory :service do
    service_name   {Faker::Internet.password(min_length: 10, max_length: 30)}
    service_status {'open'}
    service_id     {Faker::Internet.password(min_length: 20)}
    price          {Faker::Number.between(from: 100, to: 100000)}
    explanation    {Faker::Internet.password(min_length: 30, max_length: 300)}
    category_id    {Faker::Number.between(from: 2, to: 7)}
    association :user

    after(:build) do |service|
      10.times do
        service.images.attach(io: File.open('public/images/sample.png'), filename: 'sample.png')
      end
    end
  end
end
