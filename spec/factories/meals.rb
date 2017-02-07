FactoryGirl.define do
  factory :meal do
    name { "#{Faker::Food.ingredient} in #{Faker::Food.ingredient} with #{Faker::Food.spice}" }
    calories { Faker::Number.between(350, 550) }
    price { Faker::Number.decimal(2, 2) }
    day_served { %w(Sunday Monday Tuesday Wednesday Thursday Friday Saturday).sample }
  end
end
 
