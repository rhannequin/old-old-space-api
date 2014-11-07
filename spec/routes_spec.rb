require_relative './spec_helper'

describe 'routes' do
  describe 'GET /' do
    before { get '/v2' }
    let(:body) { last_response.body }
    let(:json) { parse_json body }

    it 'returns HTTP status 200' do
      expect(last_response.status).to eq 200
    end

    it 'includes 200 status code' do
      expect(body).to have_json_type(Integer).at_path('status')
      expect(json['status']).to eq(200)
    end
  end
end
