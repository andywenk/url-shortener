# frozen_string_literal: true

ruby "3.1.2"

source "https://rubygems.org"

gem "sinatra"
gem "sinatra-contrib"
gem 'sinatra-flash'
gem 'sinatra-activerecord'
gem 'activerecord', '>= 4.1'
gem "rack"
gem "rake"  
gem 'bcrypt'
gem 'warden'

group :production do
  gem "passenger"
  gem "pg"
end

group :development do
  gem "thin"
  gem "sqlite3"
  gem "rb-fsevent"
  gem "rerun"
  gem "racksh"                # https://github.com/sickill/racksh
end
