class Meal < ApplicationRecord
  belongs_to :restaurant, validate: true

  validates :restaurant, :name, :day_served, presence: true

  def image
    'http://lorempixel.com/400/300/food/'
  end

  def date_next_served
    days_enum = { 'Sunday' => 1, 'Monday' => 2,
                  'Tuesday' => 3, 'Wednesday' => 4,
                  'Thursday' => 5, 'Friday' => 6,
                  'Saturday' => 7 }

    today = Date.today.strftime('%A')
    if days_enum[today] - days_enum[day_served] <= 0
      Date.today + (days_enum[today] - days_enum[day_served]).abs
    else
      Date.today + (7 - (days_enum[today] - days_enum[day_served]))
    end
  end
end
