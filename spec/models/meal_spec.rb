require 'rails_helper'

RSpec.describe Meal do
  let!(:restaurant) { create(:restaurant) }

  describe :create do
    it 'succeeds to create a new record' do
      meal = nil
      expect { meal = create(:meal, restaurant: restaurant) }.to change { Meal.count }.by(1)
      expect(Meal.last).to eq(meal)
    end

    it 'fails to create a new record due to missing params' do
      expect { create(:meal, name: nil, day_served: nil) }.to raise_exception(ActiveRecord::RecordInvalid)
    end
  end

  describe :date_next_served do
    describe 'based on day_served calculates when the meal will be served next' do
      let!(:meal_monday) { create(:meal, restaurant: restaurant, day_served: 'Monday') }
      let!(:meal_tuesday) { create(:meal, restaurant: restaurant, day_served: 'Tuesday') }
      let!(:meal_wednesday) { create(:meal, restaurant: restaurant, day_served: 'Wednesday') }
      let!(:meal_thursday) { create(:meal, restaurant: restaurant, day_served: 'Thursday') }
      let!(:meal_friday) { create(:meal, restaurant: restaurant, day_served: 'Friday') }
      let!(:meal_saturday) { create(:meal, restaurant: restaurant, day_served: 'Saturday') }
      let!(:meal_sunday) { create(:meal, restaurant: restaurant, day_served: 'Sunday') }

      it 'calculates date if today is the same day as served' do
        today = Date.today.strftime('%A')
        meal = send("meal_#{today.downcase}".to_sym)
        expect(meal.date_next_served.strftime('%A')).to eq(today)
        expect(meal.date_next_served).to eq(Date.today)
      end

      it 'calculates if day_served was before today' do
        today = 2.days.ago.strftime('%A')
        meal = send("meal_#{today.downcase}".to_sym)
        expect(meal.date_next_served.strftime('%A')).to eq(today)
        expect(meal.date_next_served).to eq(Date.today + 5)
      end

      it 'calculates if day_served was before today' do
        today = 3.days.from_now.strftime('%A')
        meal = send("meal_#{today.downcase}".to_sym)
        expect(meal.date_next_served.strftime('%A')).to eq(today)
        expect(meal.date_next_served).to eq(Date.today + 3)
      end
    end
  end
end
