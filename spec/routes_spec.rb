require_relative './spec_helper'

describe 'routes' do
  describe 'GET /' do
    before { get '/' }

    it 'returns HTTP status 200' do
      expect(last_response.status).to eq 200
    end
  end
end
