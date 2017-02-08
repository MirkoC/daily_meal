class ApplicationController < ActionController::API
  # protect_from_forgery with: :exception
  include Rails::Pagination

  private

  def per_page
    params[:per_page] || 5
  end
end
