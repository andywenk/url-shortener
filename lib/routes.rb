# frozen_string_literal: true

require 'uri'
require 'net/http'

class App < Sinatra::Base
  before do
    @logged_in = env['warden'].authenticated?
  end

  get '/' do
    @title = "Home"
    erb :home
  end

  get '/privacy-policy' do
    erb :'privacy-policy'
  end

  get '/disclaimer' do
    erb :disclaimer
  end

  get '/toc' do
    erb :toc
  end

  get '/auth/login' do
    if env['warden'].authenticated?
      redirect '/urls'
    else 
      erb :"login"
    end
  end

  post '/auth/login' do
    turnstile = Turnstile.new({
      cf_response: params['cf-turnstile-response'],
      cf_ip: request.env["CF-Connecting-IP"]
    })

    if turnstile.check || ENV['RACK_ENV'] == 'development'
      env['warden'].authenticate!
      flash[:notice] = 'Yay! Logged in!'
      redirect '/urls'
    else 
      flash[:error] = 'Are you a robot?'
      redirect '/'
    end
  end

  get '/auth/logout' do
    env['warden'].raw_session.inspect
    env['warden'].logout
    redirect '/'
  end

  post '/auth/unauthenticated' do
    session[:return_to] = env['warden.options'][:attempted_path] if session[:return_to].nil?
    redirect '/auth/login'
  end

  get '/users' do
    session[:return_to] = '/users'
    env['warden'].authenticate!
    @title = "All Users's"
    @users = User.all
    erb :users
  end

  get '/url/:id' do
    @title = "URL for #{params[:id]}"
    @url = Url.find(params[:id])
    erb :url
  end

  post '/url/:id' do
    @title = "URL for #{params[:id]}"
    @url = Url.find(params[:id])
    erb :url
  end

  get '/urls' do 
    session[:return_to] = '/urls'
    env['warden'].authenticate!
    @title = "All URL's"
    @urls = Url.all
    erb :urls
  end

  post '/create' do
    if params[:url][:source].empty?
      slug = Slug.new
      params[:url][:source] = slug.make
    end

    url = Url.create(params[:url])
    
    if url.valid?
      flash[:notice] = 'Yay! Slug saved successfully!'
      redirect "/url/#{url.id}"
    else 
      flash[:error] = 'Sorry! This slug already exists!'
      redirect "/"
    end
  end

  get '/:url' do
    url = Url.where(source: params[:url]).take
    
    if !url.nil?
      redirect "https://#{url.target}"
      exit
    else
      @title = "URL #{params} not found"
      erb :"url-not-found"
    end
  end

  get '/url/:id/delete' do
    env['warden'].authenticate!
    url = Url.find(params[:id])
    url.destroy
    redirect "/urls"
  end

  get '/users/:id' do
    env['warden'].authenticate!
    @user = User.find(params['id'])
    haml :"users/manage"
  end
  
  post '/users/:id' do
    env['warden'].authenticate!
    @user = User.find(params['id'])
    if params[:user][:password] != '' && params[:user][:password] == params[:user][:rpassword]
      @user.assign_attributes(
        username: params[:user][:username],
        password: BCrypt::Password.create(params[:user][:password])
      )
      @user.save
    end
    redirect to("/users/#{@user.id}")
  end
end
