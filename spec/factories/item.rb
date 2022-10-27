FactoryBot.define do
  factory :item do
    name { Faker::Lorem.characters(number:10) }
    introduction { Faker::Lorem.characters(number:30) }
    price {0}
  end
end