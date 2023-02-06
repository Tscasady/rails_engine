FactoryBot.define do
  factory :item do
    name { Faker::Name.name}
    description { Faker::Lorem.paragraph}
    unit_price { Faker::Commerce.price }
    merchant { Faker::Number.number(digits: 2)}
  end
end
