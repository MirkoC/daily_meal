json.(meal, :id, :name, :price, :calories, :date_next_served, :day_served)

json.restaurant meal.restaurant, partial: 'restaurants/simple_restaurant', as: :restaurant
