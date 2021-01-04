FactoryBot.define do
  factory :user do
    name                  { Faker::Name.male_first_name }
    email                 { Faker::Internet.free_email }
    birthday              { Faker::Date.between(from: '1920-01-01', to: '2020-12-31') }
    password              { Faker::Internet.password(min_length: 6) }
    password_confirmation { password }
  end
end
