require_relative 'api_helper'

RSpec.describe User::RestaurantsController do
  describe 'api jwt authentication' do
    let(:user) { create(:user) }
    let(:correct_headers) { { 'Content-Type' => 'application/json',
                              'Accept' => 'application/json',
                              'Authorization' => "Bearer #{user.new_jwt}" } }
    let(:incorrect_headers) { { 'Content-Type' => 'application/json',
                                'Accept' => 'application/json',
                                'Authorization' => "Bearer" } }

    it 'gets restaurants and jwt passes' do
      get '/restaurants', headers: correct_headers, as: :json
      expect(response).to be_success
    end

    it 'fails and render auth errors' do
      get '/restaurants', headers: incorrect_headers, as: :json
      body = JSON.parse response.body
      expect(response).not_to be_success
      expect(body['errors']['title']).to eq('Not Authenticated')
      expect(body['errors']['bearer']).to eq(['Missing or incorrect authorization header'])
    end
  end
end
