class RestaurantsController < ApplicationController
  include JwtAuth

  before_action :authenticate_request!

  def index
    render json: Restaurant.all
  end
end
