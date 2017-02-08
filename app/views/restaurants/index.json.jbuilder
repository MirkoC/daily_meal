json.array!(@restaurants) do |r|
  json.partial! 'restaurant', restaurant: r
end