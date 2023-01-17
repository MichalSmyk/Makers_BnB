require 'sinatra/base'
require 'sinatra/reloader'
require "sinatra/activerecord"
require_relative "../../config/environment"


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
    @user = User.new #so you can see user from space page
    @availability = SpaceDate.new #so you can see availability on the space page
    @space = Space.new #so you can see info about the listing
    erb :spaces_id
  end 



end