require 'sinatra/base'
require 'sinatra/cross_origin'
require 'sinatra/config_file'
require 'sinatra/namespace'
require 'sinatra/reloader'

require 'logger'
require 'json'

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

      get '' do
        json_response 200, { location: :root }
      end

    end

    not_found do
      error_response :not_found_error
    end
  end

end
