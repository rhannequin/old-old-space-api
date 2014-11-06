require 'rack/test'
require 'json_spec'

ENV['RACK_ENV'] = 'test'

require_relative File.join('..', 'app')

RSpec.configure do |config|
  include Rack::Test::Methods
  include JsonSpec::Helpers

  def app
    SpaceApi::App
  end
end
