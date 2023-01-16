require_relative "./config/environment"
require 'rubygems'
require './app/controllers/application_controller'
require './app/models/booking'
require './app/models/space'
require './app/models/user'
require_relative './app'
run ApplicationController