require 'sinatra'
require 'sinatra/base'
require 'sinatra/config_file'
require "sinatra/activerecord"
require 'sinatra/custom_logger'
require 'sinatra/flash'
require 'sinatra/cross_origin'
require 'pstore'
require 'logger'
require 'warden'
require 'bcrypt'
require 'rack/protection'

Dir['./lib/*.rb'].each { |file| require_relative file }
Dir['./models/*.rb'].each { |file| require_relative file }

class App < Sinatra::Base
  set :root, File.dirname(__FILE__)
  set :sessions, true
  set :database_file, 'config/database.yml'

  use Rack::Session::Pool
  
  register Sinatra::ConfigFile
  config_file '/config/config.yml'

  register Sinatra::CrossOrigin

  configure do
    enable :cross_origin
  end
  
  set :allow_origin, :any
  set :allow_methods, [:get, :post, :put, :delete, :options]
  set :allow_credentials, true
  set :max_age, "1728000"
  set :expose_headers, ['Content-Type']

  before do
    response.headers['Access-Control-Allow-Origin'] = '*'
  end

  options "*" do
    response.headers["Allow"] = "HEAD,GET,PUT,POST,DELETE,OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept, Authorization, X-User-Email, X-Auth-Token"
    response.headers["Access-Control-Allow-Origin"] = "*"
    200
  end

  use Rack::MethodOverride
  set :method_override, true

  set :public_folder, __dir__ + '/public'

  register Sinatra::Flash

  helpers Sinatra::CustomLogger

  configure :production do
    logger = Logger.new(File.open("#{root}/log/#{environment}.log", 'a'))
    logger.level = Logger::INFO
    set :logger, logger
  end

  configure :development do
    logger = Logger.new(STDOUT)
    logger.level = Logger::DEBUG
    set :logger, logger
  end

  use Rack::Protection
end

