FactoryGirl.define do
  factory :restaurant do
    name { "#{Faker::Company.name} #{['Spicy Diner', 'Place', 'Restaurant', 'Eating House', 'Diner', 'Meals', 'Pancakes', 'Food', 'Oriental Meals'].sample}" }
    address { "#{Faker::Address.street_address}, #{Faker::Address.city}" }
    website { Faker::Internet.url }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
    logo { Faker::Company.logo }
  end
end
