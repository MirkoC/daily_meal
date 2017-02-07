require 'rails_helper'

RSpec.describe Meal do
  describe :create do
    it 'succeeds to create a new record' do
      restaurant = nil
      expect { restaurant = create(:restaurant) }.to change { Restaurant.count }.by(1)
      expect(Restaurant.last).to eq(restaurant)
    end

    it 'fails to create a new record due to missing params' do
      expect { create(:restaurant, name: nil, address: nil) }.to raise_exception(ActiveRecord::RecordInvalid)
    end
  end
end
