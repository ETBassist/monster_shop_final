FactoryBot.define do
  factory :user do
    name { Faker::Superhero.name }
    address { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state_abbr}
    zip { Faker::Address.zip }
    sequence(:email) { |n| "user#{n}@domain.com" }
    password { "SomePassword" }
  end
end
