require 'rails_helper'

RSpec.shared_context 'seed_data' do
  let!(:restaurant_1) { create(:restaurant, name: 'Simple Restaurant', city: 'Zagreb', latitude: 45.71101, longitude: 15.92111) }
  let!(:restaurant_2) { create(:restaurant, name: 'Test Diner', city: 'Zagreb', latitude: 45.72, longitude: 16.5 ) }
  let!(:restaurant_3) { create(:restaurant, name: 'Simple Pancakes', city: 'Ljubljana', latitude: 46.055, longitude: 14.505) }
  let!(:restaurant_4) { create(:restaurant, name: 'Test Restaurant', city: 'Ljubljana', latitude: 46.07, longitude: 14.509) }
  let!(:restaurant_5) { create(:restaurant, name: 'Simple Diner', city: 'Ljubljana', latitude: 46.03, longitude: 14.511) }
  let!(:meal_names_1) { ['Beans in Stew with Paper', 'Carrot in Water with Salt', 'Meat in Potato with Cinemon Powder', 'Beans in Potato with Salt'] }
  let!(:meal_names_2) { ['Onion in Duck with Ginger Root', 'Lettuce in Water with Curry', 'Meat in Potato with Cinemon Powder', 'Tomato in Potato with Salt'] }

  let!(:meals_1) do
    meal_names_1.each do |name|
      create(:meal, restaurant: restaurant_1, name: name)
    end
  end

  let!(:meals_2) do
    meal_names_2.each do |name|
      create(:meal, restaurant: restaurant_2, name: name)
    end
  end

  let!(:meals_3) do
    meal_names_1.each do |name|
      create(:meal, restaurant: restaurant_3, name: name)
    end
  end

  let!(:meals_4) do
    meal_names_2.each do |name|
      create(:meal, restaurant: restaurant_4, name: name)
    end
  end

  let!(:meals_5) do
    meal_names_1.each do |name|
      create(:meal, restaurant: restaurant_5, name: name)
    end
  end
end
