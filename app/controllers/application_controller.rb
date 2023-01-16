require 'sinatra/base'
require 'sinatra/reloader'
require "sinatra/activerecord"
require_relative "../../config/environment"


class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    @user = Users.all
    return erb(:index)
  end
end