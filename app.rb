require 'sinatra'
require 'base64'
require 'pstore'
require 'logger'
require 'warden'
require 'bcrypt'
require 'rack/protection'

Dir['./lib/*.rb'].each { |file| require_relative file }
Dir['./lib/models/*.rb'].each { |file| require_relative file }

class App < Sinatra::Application
  use Rack::MethodOverride
  set :method_override, true

  use Rack::Session::Pool

  set :logger, Logger.new(STDOUT)
  set :public_folder, __dir__ + '/public'

  use Rack::Protection
end

