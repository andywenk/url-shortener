# frozen_string_literal: true

ruby "3.1.2"

source "https://rubygems.org"
git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

# gem "sinatra"
gem 'sinatra', :github => 'sinatra/sinatra'
gem "sinatra-contrib"
gem 'sinatra-flash'
gem 'sinatra-activerecord'
gem 'sinatra-cross_origin'
gem 'activerecord', '>= 4.1'
gem "rack"
gem "rake"  
gem 'bcrypt'
gem 'warden'

group :development do
  gem "thin"
  gem "sqlite3"
  gem "rb-fsevent"
  gem "rerun"
  gem "racksh"                # https://github.com/sickill/racksh
end

group :production do
  gem "passenger"
  gem "pg"
end
