class MealsController < ApplicationController
  include JwtAuth

  before_action :authenticate_request!

  def index
    @meals = paginate load_collection, per_page: per_page
  end

  def show
    @meal = Meal.find_by_id(params[:id])
    if @meal
      render :show
    else
      render json: { errors: { meal: [:not_found] } }, status: :not_found
    end
  end

  private

  def chain_start
    Meal
  end

  def load_collection
    start = chain_start.all
    start = start.where('meals.name ILIKE ?', "%#{params[:meal_name]}%") if params[:meal_name]
    start
  end
end
