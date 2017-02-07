require_relative '../api_helper'

RSpec.describe User::RegistrationsController do
  include_context 'api_helper'
  describe :create do
    let!(:signup_params) { { email: 'test@email.some', password: '12345678', password_confirmation: '12345678' } }

    it 'creates a new user and returns jwt token' do
      post '/users', params: signup_params, headers: headers, as: :json
      body = JSON.parse response.body
      expect(response).to be_success
      expect(body['id']).to be
      expect(body['email']).to be
      expect(body['bearer']).to be
      user = User.find_by_email(signup_params[:email])
      expect(user.id).to eq(body['id'])
    end

    it 'cannot create a new user since passwords do not match' do
      wrong_signup_params = { email: 'test@email.some',
                              password: '12345678',
                              password_confirmation: 'wrong' }
      post '/users', params: wrong_signup_params, headers: headers, as: :json
      body = JSON.parse response.body
      expect(response).not_to be_success
      expect(response.status).to eq(400)
      expect(User.find_by_email(wrong_signup_params[:email])).not_to be
      expect(body['errors']['password_confirmation']).to eq(['doesn\'t match Password'])
    end

    it 'cannot create a new user since user already exists' do
      User.create(signup_params)
      post '/users', params: signup_params, headers: headers, as: :json
      body = JSON.parse response.body
      expect(response).not_to be_success
      expect(response.status).to eq(400)
      expect(body['errors']['email']).to eq(['has already been taken'])
    end
  end
end
