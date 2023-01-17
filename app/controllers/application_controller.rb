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
end
