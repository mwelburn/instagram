class HomeController < ApplicationController
  require "instagram"

  CALLBACK_URL = "http://localhost:3000"
  CLIENT_ID = "b91ac9d30d814251b62dfa87df40b356"
  CLIENT_SECRET = "fd6595543bdc411a921002cf0f67bb66"

  Instagram.configure do |config|
    config.client_id = CLIENT_ID
    config.client_secret = CLIENT_SECRET
  end
  
  def index
    client = Instagram.client
    all_media = client.media_popular
    #render :json => all_media

     @media = all_media
  end

  def user
    if (params[:code])
      response = Instagram.get_access_token(params[:code], :redirect_uri => CALLBACK_URL)
      #response = Instagram.get_access_token(params[:code], :redirect_uri => CALLBACK_URL, :client_id => CLIENT_ID, :client_secret => CLIENT_SECRET, :grant_type => "authorization_code")
      session[:access_token] = response.access_token
      redirect_to user_path
    elsif (session[:access_token])
      client = Instagram.client(:access_token => session[:access_token])
      user = client.user

      #render :text => client.user_recent_media(user.id)
      @media = client.user_recent_media(user.id)
      #render :text => @media.first
    else
      redirect_to Instagram.authorize_url(:redirect_uri => CALLBACK_URL)
    end
  end

end
