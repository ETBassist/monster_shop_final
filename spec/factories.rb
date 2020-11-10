FactoryBot.define do
  factory :user do
    name { Faker::Superhero.name }
    sequence(:email) { |n| "user#{n}@domain.com" }
    password { "SomePassword" }
  end

  factory :merchant do
    name { Faker::Books::Lovecraft.deity }
    address { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state_abbr}
    zip { Faker::Address.zip }
    enabled { true }
  end
end
