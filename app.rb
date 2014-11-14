require 'sinatra/base'
require 'sinatra/cross_origin'
require 'sinatra/config_file'
require 'sinatra/namespace'
require 'sinatra/reloader'

require 'logger'
require 'json'
require 'open-uri'
require 'nokogiri'

require_relative 'space_api_helpers'

module SpaceApi

  class App < Sinatra::Base
    register Sinatra::ConfigFile
    register Sinatra::CrossOrigin
    register Sinatra::Namespace

    set :environments, %w(production development test)
    set :environment, (ENV['RACK_ENV']||ENV['SPACEAPI_APPLICATION_ENV']||:development).to_sym

    set :allow_origin, :any
    set :allow_methods, %i(get)
    set :expose_headers, %w(Content-Type)

    config_file 'config_file.yml'

    configure do
      enable :logging
      enable :cross_origin
      set :api_version, :v2
    end

    configure :production do
      set :logging, Logger::INFO
    end

    configure :development do
      register Sinatra::Reloader
    end

    configure %w(development test) do
      set :logging, Logger::DEBUG
    end

    helpers do
      include SpaceApi::Helpers
    end

    namespace "/#{settings.api_version}" do

      get '/' do
        scientific_notation "Scientific Notation: 6.9551 x 105 km"
        json_response 200, { location: :root }
      end

      get '/sun' do
        file = open('http://solarsystem.nasa.gov/planets/profile.cfm?Object=Sun&Display=Facts&System=Metric')
        doc = Nokogiri::HTML(file.read)
        tables = doc.css('.bodyContentTab > table table table table .l2featuretext')
        sun = {
          discovered_by: tables[0].content.strip,
          discovery_date: tables[1].content.strip,
          equatorial_inclination: tables[2].content.strip.to_f,
          mean_radius: scientific_notation(tables[5].content.strip),
          equatorial_circumference: scientific_notation(tables[8].content.strip),
          volume: scientific_notation(tables[11].content.strip)
        }
        json_response 200, { data: sun }
      end

      get '/health_check' do
        routes = %w( / /sun )
        statuses = {}
        status = 'ok'
        routes.each do |r|
          route = "/#{settings.api_version}#{r}"
          response = call env.merge('PATH_INFO' => route)
          if response.first == 200
            statuses[route] = 'ok'
          else
            status = 'ko'
            statuses[route] = 'ko'
          end
          statuses[route] = response.first == 200 ? 'ok' : 'ko'
        end
        json_response 200, { routes: statuses, health_check: status }
      end

    end

    not_found do
      error_response :not_found_error
    end
  end

end
