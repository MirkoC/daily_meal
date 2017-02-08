json.(restaurant, :id, :name, :city, :address, :website, :latitude, :longitude, :logo)

json.meals restaurant.meals do |meal|
  json.partial! 'meals/meal', meal: meal
end