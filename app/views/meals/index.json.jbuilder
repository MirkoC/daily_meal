json.array!(@meals) do |m|
  json.partial! 'meal_with_restaurant', meal: m
end