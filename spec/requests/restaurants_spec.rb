require_relative 'api_helper'
require_relative '../test_seed'

RSpec.describe RestaurantsController do
  include_context 'api_helper'
  include_context 'seed_data'

  describe :index do
    it 'gets all of the restaurants (5 per page)' do
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
