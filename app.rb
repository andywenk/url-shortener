require 'sinatra'
# require 'sinatra_more'
require 'base64'
require 'pstore'
require 'logger'
require_relative 'lib/routes'

set :logger, Logger.new(STDOUT)

class App < Sinatra::Application
  # register SinatraMore::MarkupPlugin
  # register SinatraMore::RenderPlugin
  # register SinatraMore::WardenPlugin
  # register SinatraMore::MailerPlugin
  # register SinatraMore::RoutingPlugin
end

