require_relative 'url'

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
