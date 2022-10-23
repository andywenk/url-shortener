require 'sinatra'
require 'sinatra/base'
require 'sinatra/config_file'
require "sinatra/activerecord"
require 'sinatra/custom_logger'
require 'sinatra/flash'
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
  use Rack::Session::Pool
  
  register Sinatra::ConfigFile
  config_file '/config/config.yml'

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

