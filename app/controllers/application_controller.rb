require 'sinatra/base'
require 'sinatra/reloader'
require "sinatra/activerecord"
require_relative "../../config/environment"
require_relative '../models/user'
require_relative '../models/booking'
require_relative '../models/space_date'
require_relative '../models/space'

class ApplicationController < Sinatra::Base
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
    @user = @space.user
    @available = @space.space_date
    erb :spaces_id
  end 



end