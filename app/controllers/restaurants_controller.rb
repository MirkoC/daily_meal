class RestaurantsController < ApplicationController
  include JwtAuth

  before_action :authenticate_request!

  def index
    @restaurants = paginate load_collection, per_page: per_page
  end

  def show
    @restaurant = Restaurant.find_by_id(params[:id])
    if @restaurant
      render :show
    else
      render json: { errors: { restaurant: [:not_found] } }, status: :not_found
    end
  end

  private

  def chain_start
    Restaurant
  end

  def load_collection
    start = chain_start.all
    start = include_city_in_search(params[:city], start) if params[:city]
    start = include_restaurant_name_in_search(params[:restaurant_name], start) if params[:restaurant_name]
    start = geo_search(params[:lat], params[:lng], start)
    start = include_meal_name_in_search(params[:meal_name], start) if params[:meal_name]

    start
  end

  def include_city_in_search(value, collection)
    collection.where('city ILIKE ?', "%#{value}%")
  end

  def include_restaurant_name_in_search(value, collection)
    collection.where('restaurants.name ILIKE ?', "%#{value}%")
  end

  def geo_search(lat, lng, collection)
    if lat && lng
      collection = collection.where("latitude >= ? - 0.05 AND latitude <= ? + 0.05 AND "\
                                    "longitude >= ? - 0.05 AND longitude <= ? + 0.05", lat, lat, lng, lng)
    elsif lat
      collection = collection.where("latitude >= ? - 0.05 AND latitude <= ? + 0.05", lat, lat)
    elsif lng
      collection = collection.where("longitude >= ? - 0.05 AND longitude <= ? + 0.05", lng, lng)
    end

    collection
  end

  def include_meal_name_in_search(value, collection)
    collection.joins(:meals).where('meals.name ILIKE ?', "%#{value}%").distinct.order(id: :asc)
  end
end
