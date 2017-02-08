require_relative 'api_helper'

RSpec.describe RestaurantsController do
  include_context 'api_helper'

  let(:user) { create(:user) }
  let(:headers) { { 'Content-Type' => 'application/json',
                    'Accept' => 'application/json',
                    'Authorization' => "Bearer #{user.new_jwt}" } }
  let!(:restaurant_1) { create(:restaurant, name: 'Simple Restaurant', city: 'Zagreb', latitude: 45.71101, longitude: 15.92111) }
  let!(:restaurant_2) { create(:restaurant, name: 'Test Diner', city: 'Zagreb', latitude: 45.72, longitude: 16.5 ) }
  let!(:restaurant_3) { create(:restaurant, name: 'Simple Pancakes', city: 'Ljubljana', latitude: 46.055, longitude: 14.505) }
  let!(:restaurant_4) { create(:restaurant, name: 'Test Restaurant', city: 'Ljubljana', latitude: 46.07, longitude: 14.509) }
  let!(:restaurant_5) { create(:restaurant, name: 'Simple Diner', city: 'Ljubljana', latitude: 46.03, longitude: 14.511) }
  let!(:meal_names_1) { ['Beans in Stew with Paper', 'Carrot in Water with Salt', 'Meat in Potato with Cinemon Powder', 'Beans in Potato with Salt'] }
  let!(:meal_names_2) { ['Onion in Duck with Ginger Root', 'Lettuce in Water with Curry', 'Meat in Potato with Cinemon Powder', 'Tomato in Potato with Salt'] }

  let!(:meals_1) do
    meal_names_1.each do |name|
      create(:meal, restaurant: restaurant_1, name: name)
    end
  end

  let!(:meals_2) do
    meal_names_2.each do |name|
      create(:meal, restaurant: restaurant_2, name: name)
    end
  end

  let!(:meals_3) do
    meal_names_1.each do |name|
      create(:meal, restaurant: restaurant_3, name: name)
    end
  end

  let!(:meals_4) do
    meal_names_2.each do |name|
      create(:meal, restaurant: restaurant_4, name: name)
    end
  end

  let!(:meals_5) do
    meal_names_1.each do |name|
      create(:meal, restaurant: restaurant_5, name: name)
    end
  end

  describe :index do
    it 'gets all of the restaurants' do
      get '/restaurants', headers: headers, as: :json
      expect(response).to be_success
      body = JSON.parse response.body
      expect(body.length).to eq(5)
    end

    it 'gets only restaruants from Zagreb' do
      get '/restaurants', params: { city: 'Zagreb' }, headers: headers, as: :json
      expect(response).to be_success
      body = JSON.parse response.body
      expect(body.length).to eq(2)
      expect(body.first['city']).to eq('Zagreb')
    end

    it 'gets only restaruants from Ljubljana even if city name was not complete' do
      get '/restaurants', params: { city: 'Ljublj' }, headers: headers, as: :json
      expect(response).to be_success
      body = JSON.parse response.body
      expect(body.length).to eq(3)
      expect(body.first['city']).to eq('Ljubljana')
    end

    it 'gets only restaruants where beans are served' do
      get '/restaurants', params: { meal_name: 'Beans' }, headers: headers, as: :json
      expect(response).to be_success
      body = JSON.parse response.body
      expect(body.length).to eq(3)
    end

    it 'gets only restaruants where Lettuce is served even if meal name was not complete' do
      get '/restaurants', params: { meal_name: 'ttuce' }, headers: headers, as: :json
      expect(response).to be_success
      body = JSON.parse response.body
      expect(body.length).to eq(2)
    end

    it 'gets only restaruants with close latitudes' do
      get '/restaurants', params: { lat: 46.05 }, headers: headers, as: :json
      expect(response).to be_success
      body = JSON.parse response.body
      expect(body.length).to eq(3)
      expect(body.first['city']).to eq('Ljubljana')
    end

    it 'gets only restaruants with close both latitudes and longitudes' do
      get '/restaurants', params: { lat: 45.7, lng: 15.9 }, headers: headers, as: :json
      expect(response).to be_success
      body = JSON.parse response.body
      expect(body.length).to eq(1)
      expect(body.first['city']).to eq('Zagreb')
    end

    it 'gets only restaruants with similar names' do
      get '/restaurants', params: { restaurant_name: 'Diner' }, headers: headers, as: :json
      expect(response).to be_success
      body = JSON.parse response.body
      expect(body.length).to eq(2)

      get '/restaurants', params: { restaurant_name: 'Pancakes' }, headers: headers, as: :json
      expect(response).to be_success
      body = JSON.parse response.body
      expect(body.length).to eq(1)
    end

    it 'finds restaurant by all params' do
      req_params = { city: 'Ljubljana', restaurant_name: 'Restaurant',
                     lat: 46.11, lng: 14.5, meal_name: 'Meat in Potato' }
      get '/restaurants', params: req_params, headers: headers, as: :json
      expect(response).to be_success
      body = JSON.parse response.body
      expect(body.length).to eq(1)
      expect(body.first['id']).to eq(restaurant_4.id)
    end
  end

  describe :show do
    it 'gets the restaurant by id' do
      get "/restaurants/#{restaurant_5.id}", headers: headers, as: :json
      expect(response).to be_success
      body = JSON.parse response.body
      expect(body['id']).to eq(restaurant_5.id)
    end

    it 'renders not found response if the restaurant do not exists' do
      get "/restaurants/#{restaurant_5.id + 1}", headers: headers, as: :json
      expect(response).not_to be_success
      body = JSON.parse response.body
      expect(body['errors']['restaurant']).to eq(['not_found'])
    end
  end
end
