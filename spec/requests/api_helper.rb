require 'rails_helper'

RSpec.shared_context 'api_helper' do
  let(:basic_headers) do
    { 'Content-Type' => 'application/json',
      'Accept' => 'application/json' }
  end
end
