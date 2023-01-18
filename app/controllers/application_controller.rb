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
    if sign_up_field_empty?
      erb(:sign_up_blank)
    elsif !password_and_repeat_password_match
      erb(:sign_up_password_fail)
    elsif username_not_available
      erb(:username_taken)
    else
      create_user_and_login
      erb(:user_created)
    end
  end

  get '/stays-management' do
    @user_pending_stays = []
    @user = current_user
    @user_bookings = Booking.where(user_id: @user.id)
    erb(:stays_management)
  end
end
