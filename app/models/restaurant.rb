class Restaurant < ApplicationRecord
  has_many :meals, autosave: true

  validates :name, :address, :city, presence: true

  def self.search_by_city(city)
    Restaurant.where(city: city)
  end

  def self.search_by_restaurant_name(name)
    Restaurant.where(name: name)
  end
end
