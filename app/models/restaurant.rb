class Restaurant < ApplicationRecord
  has_many :meals, autosave: true

  validates :name, :address, presence: true
end
