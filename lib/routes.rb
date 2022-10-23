# frozen_string_literal: true

class App < Sinatra::Application
  get '/' do
    @title = "Home"
    erb :home
  end

  get '/url/:id' do
    @title = "URL for #{params[:id]}"
    @url = Url.find(params[:id])
    erb :url
  end

  get '/urls' do 
    env['warden'].authenticate!
    @title = "All URL's"
    @urls = Url.all
    erb :urls
  end

  post '/create' do
    url = Url.create(params[:url])
    redirect to("/url/#{url.id}")
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
    url = Url.find(params[:id])
    url.destroy
    redirect to("/urls")
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

  get '/auth/login' do
    erb :"login"
  end

  post '/auth/login' do
    env['warden'].authenticate!

    # flash[:success] = 'Successfully logged in'

    if session[:return_to].nil?
      redirect '/'
    else
      redirect session[:return_to]
    end
  end

  get '/auth/logout' do
    env['warden'].raw_session.inspect
    env['warden'].logout
    # flash[:success] = 'Successfully logged out'
    redirect '/'
  end

  post '/auth/unauthenticated' do
    session[:return_to] = env['warden.options'][:attempted_path] if session[:return_to].nil?
    # Set the error and use a fallback if the message is not defined
    # flash[:error] = env['warden.options'][:message] || 'You must log in'
    redirect '/auth/login'
  end
end
