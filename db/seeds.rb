FactoryGirl.create(:user, email: 'test@example.example', password: '12345678')

80.times do
  restaurant = FactoryGirl.create(:restaurant)
  Faker::Number.between(15, 25).times do
    FactoryGirl.create(:meal, restaurant: restaurant)
  end
end
