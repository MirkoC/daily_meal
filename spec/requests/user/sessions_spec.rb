require_relative '../api_helper'

RSpec.describe User::SessionsController do
  include_context 'api_helper'

  describe :create do
    let!(:user) { User.create(email: 'test@email.some', password: '12345678') }

    it 'returns user response with jwt token' do
      signin_params = { email: user.email, password: '12345678' }
      post '/users/sign_in', params: signin_params, headers: headers, as: :json
      body = JSON.parse response.body
      expect(response).to be_success
      expect(body['id']).to be
      expect(body['email']).to be
      expect(body['bearer']).to be
      expect(user.id).to eq(body['id'])
    end

    it 'returns cannot find user response' do
      unknown_user_params = { email: 'wrong.email@test.some', password: '12345678' }
      post '/users/sign_in', params: unknown_user_params, headers: headers, as: :json
      body = JSON.parse response.body
      expect(response).not_to be_success
      expect(body['errors']['user']).to eq(['not_found'])
    end

    it 'returns invalid password response' do
      wrong_user_params = { email: user.email, password: 'wrong' }
      post '/users/sign_in', params: wrong_user_params, headers: headers, as: :json
      body = JSON.parse response.body
      expect(response).not_to be_success
      expect(body['errors']['password']).to eq(['invalid_password'])
    end
  end
end
