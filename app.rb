require 'sinatra'
require 'base64'
require 'pstore'
require 'logger'
require_relative 'lib/routes'

set :logger, Logger.new(STDOUT)
set :public_folder, __dir__ + '/public'

class App < Sinatra::Application
  
end

