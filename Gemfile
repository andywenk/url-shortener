# frozen_string_literal: true

ruby "3.1.2"

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gem "sinatra"
gem "base64"
gem "rack"
gem "rake"  
gem 'sinatra-activerecord'
gem 'activerecord', '>= 4.1'
gem "passenger"
gem 'bcrypt'
gem 'warden'

group :production do
  gem "pg"
end

group :development do
  gem "thin"
  gem "sqlite3"
  gem "rb-fsevent"
  gem "rerun"
  gem "racksh"
end
