require_relative 'api_helper'
require_relative '../test_seed'

RSpec.describe MealsController do
  include_context 'api_helper'
  include_context 'seed_data'

  describe :index do
    it 'gets all of the meals (5 per page)' do
      get '/meals', headers: headers, as: :json
      expect(response).to be_success
      body = JSON.parse response.body
      expect(body.length).to eq(5)
    end

    it 'gets only meals with beans' do
      get '/meals', params: { meal_name: 'Carrot' }, headers: headers, as: :json
      expect(response).to be_success
      body = JSON.parse response.body
      expect(body.length).to eq(3)
    end
  end

  describe :show do
    it 'gets the meal by id' do
      meal = Meal.second
      get "/meals/#{meal.id}", headers: headers, as: :json
      expect(response).to be_success
      body = JSON.parse response.body
      expect(body['id']).to eq(meal.id)
    end

    it 'renders not found response if the meal do not exists' do
      meal = Meal.last
      get "/meals/#{meal.id + 1}", headers: headers, as: :json
      expect(response).not_to be_success
      body = JSON.parse response.body
      expect(body['errors']['meal']).to eq(['not_found'])
    end
  end
end
