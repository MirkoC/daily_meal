require 'rails_helper'

RSpec.shared_context 'api_helper' do
  let(:basic_headers) do
    { 'Content-Type' => 'application/json',
      'Accept' => 'application/json' }
  end

  let(:user) { create(:user) }
  let(:headers) { { 'Content-Type' => 'application/json',
                    'Accept' => 'application/json',
                    'Authorization' => "Bearer #{user.new_jwt}" } }
end
