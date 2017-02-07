class Restaurant < ApplicationRecord
  has_many :meals, autosave: true

  validates :name, :address, :city, presence: true
end
