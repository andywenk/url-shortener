require 'sinatra'
require 'base64'
require 'pstore'

get '/' do
  @title = "Da cool stuff"
  erb :home
end

get '/:url' do
  "URL is #{params[:url]}"
end

post '/create-shorturl' do
  params
end

