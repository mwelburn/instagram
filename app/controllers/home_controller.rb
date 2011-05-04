class HomeController < ApplicationController
  require "instagram"

  CALLBACK_URL = "http://www.michaelwelburn.com:3000"
  CLIENT_ID = "b91ac9d30d814251b62dfa87df40b356"
  CLIENT_SECRET = "fd6595543bdc411a921002cf0f67bb66"

  Instagram.configure do |config|
    config.client_id = CLIENT_ID
    config.client_secret = CLIENT_SECRET
  end
  
  def index
    if (params[:code])
      response = Instagram.get_access_token(params[:code], :redirect_uri => CALLBACK_URL)
      #response = Instagram.get_access_token(params[:code], :redirect_uri => CALLBACK_URL, :client_id => CLIENT_ID, :client_secret => CLIENT_SECRET, :grant_type => "authorization_code")
      session[:access_token] = response.access_token
      redirect_to :root
    elsif (session[:access_token])
      client = Instagram.client(:access_token => session[:access_token])
      user = client.user

      render :text => user
    else
      redirect_to Instagram.authorize_url(:redirect_uri => CALLBACK_URL)
    end
  end

end
