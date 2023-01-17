require 'sinatra/base'
require 'sinatra/reloader'
require "sinatra/activerecord"
require_relative "../../config/environment"
require_relative '../models/user'
require_relative '../models/booking'
require_relative '../models/space_date'
require_relative '../models/space'
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


  get '/space/:id' do 
    @space = Space.find_by(id: params[:id])
    @ava = SpaceDate.find_by(id: params[:id])
    @user = @space.user
    @dates = @ava
    @booking = Booking.create(stay_date: params[:stay_date], request_time: params[:request_time],
      request_approval: params[:request_approval], space_id: params[:space_id], user_id: params[:user_id])
    erb :spaces_id
  end 

  post '/space/:id' do 
    @space = Space.find_by(id: params[:id])
    if logged_in?
     erb :booking_confirmation
    else 
      nil
    end
  end 

end