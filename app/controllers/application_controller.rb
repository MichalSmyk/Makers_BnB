require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require_relative '../../config/environment'
require_relative '../helpers/session_helper'

class ApplicationController < Sinatra::Base
  include SessionHelper
  enable :sessions
  register Sinatra::ActiveRecordExtension
  configure :development do
    register Sinatra::Reloader
  end

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get '/' do
    @spaces = Space.all
    erb(:index)
  end

  post '/login' do
    log_in
    @spaces = Space.all
    erb(:index)
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

  get '/signup' do
    if logged_in?
      erb(:home_page_redirect)
    else
      erb(:signup)
    end
  end

  post '/signup' do
    if params[:username].empty? || 
      params[:email].empty? || 
      params[:password].empty? || 
      params[:repeat_password].empty? || 
      params[:first_name].empty? || 
      params[:last_name].empty? ||
      params[:mobile_number].empty?
      erb(:sign_up_blank)
    elsif params[:password] != params[:repeat_password]
      erb(:sign_up_password_fail)
    elsif User.find_by(username: params[:username])
      erb(:username_taken)
    else
      @user = User.create(username: params[:username], email: params[:email], 
        password: params[:password], first_name: params[:first_name], last_name: params[:last_name])
        
      session[:user_id] = @user.id 
      
      erb(:user_created)
    end
  end
end
