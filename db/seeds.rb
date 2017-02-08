FactoryGirl.create(:user, email: 'test@example.example', password: '12345678')

80.times do
  restaurant = FactoryGirl.create(:restaurant)
  Faker::Number.between(15, 25).times do
    FactoryGirl.create(:meal, restaurant: restaurant)
  end
end

10.times do
  restaurant = FactoryGirl.create(:restaurant, city: 'Zagreb',
                                               latitude: Faker::Number.normal(45.815011, 0.05),
                                               longitude: Faker::Number.normal(15.981919, 0.05))
  Faker::Number.between(15, 25).times do
    FactoryGirl.create(:meal, restaurant: restaurant)
  end
end

10.times do
  restaurant = FactoryGirl.create(:restaurant, city: 'Ljubljana',
                                               latitude: Faker::Number.normal(46.056947, 0.05),
                                               longitude: Faker::Number.normal(14.505751, 0.05))
  Faker::Number.between(15, 25).times do
    FactoryGirl.create(:meal, restaurant: restaurant)
  end
end
