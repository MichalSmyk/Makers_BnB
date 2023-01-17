require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require_relative '../../config/environment'

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

  get '/' do
    @spaces = Space.all
    return erb(:index)
  end
end
