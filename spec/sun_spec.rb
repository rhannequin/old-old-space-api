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
      expect(body).to have_json_path('data/mean_radius')
      expect(body).to have_json_path('data/equatorial_circumference')
      expect(body).to have_json_path('data/volume')
      expect(body).to have_json_path('data/mass')
      expect(body).to have_json_path('data/density')
      expect(body).to have_json_path('data/surface_area')
      expect(body).to have_json_path('data/surface_gravity')
      expect(body).to have_json_path('data/escape_velocity')
      expect(body).to have_json_path('data/sidereal_rotation_period')
      expect(body).to have_json_path('data/surface_temperature')
      expect(body).to have_json_path('data/effective_temperature')
    end
  end
end
