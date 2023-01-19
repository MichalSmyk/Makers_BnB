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
    erb(:index_redirect)
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

  get '/myaccount' do
    erb(:user_account)
  end

  get '/space/:id' do
    load_space
    erb :space_id
  end

  get '/space/book/:id' do
    book_space_date_choice
    erb(:book)
  end

  post '/space/book/:id' do
    create_new_booking
    erb(:booking_confirmation)
  end

  get '/stays-management' do
    stays_approval_status
    erb(:stays_management)
  end

  post '/stays-management/delete/:id' do
    booking = Booking.find_by(id: params[:id])
    booking.destroy
    erb(:delete_confirmed_redirect_stays_management)
  end
end
