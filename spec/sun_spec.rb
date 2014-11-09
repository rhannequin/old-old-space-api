require_relative './spec_helper'

describe 'Sun' do
  describe 'GET /v2/sun' do
    before { get '/v2/sun' }
    let(:body) { last_response.body }
    let(:json) { parse_json body }

    it 'includes all expected keys' do
      expect(body).to have_json_path('data/discovered_by')
      expect(body).to have_json_path('data/discovery_date')
      expect(body).to have_json_path('data/equatorial_inclination')
    end
  end
end
