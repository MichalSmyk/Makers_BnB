require 'spec_helper'
require 'rack/test'
require_relative '../../app/controllers/application_controller'
require 'json'
require "sinatra/base"
require "sinatra/activerecord"

describe ApplicationController do
  include Rack::Test::Methods

  let(:app) { ApplicationController.new }
  context 'GET /' do
    it 'should get the homepage' do
      response = get('/')
      expect(response.status).to eq(200)
      expect(response.body).to include '<h1>Welcome to MakersBnB!</h1>'
    end
    it 'should display a login field and a link to sign-up page' do
      response = get('/')
      expect(response.body).to include "<form action='/login' method='POST'>"
      expect(response.body).to include "<a href= '/signup'>Click here to sign up</a>"
    end
    it 'should provide a list of spaces' do
      response = get('/')
      expect(response.body).to include 'Lovely Cottage'
    end
  end
  context 'POST to /login' do
    it 'logs in with valid credentials' do
      response = post('/login', username: 'abodian', password: 'test')
      expect(response.status).to eq(200)
      expect(response.body).to include 'You are logged in as'
    end

    it 'remains logged in when navigating site' do
      post '/login', { username: 'abodian', password: 'test' }
      response = get('/')
      expect(response.body).to include 'You are logged in as'
    end

    it 'will not signin with invalid credentials' do
      response = post('/login', username: 'abodian', password: 'wrong')
      expect(response.status).to eq(200)
      expect(response.body).not_to include 'You are logged in as'
    end
  end

  context 'GET to /logout' do
    it 'removes session variables' do
      post '/login', { username: 'abodian', password: 'test' }
      response = get('/logout')
      expect(last_response.location).to eq 'http://example.org/'
      expect(session[:user_id]).to eq nil
    end
  end

  context 'GET /signup' do
    it 'should get the signup page as not logged in' do
      response = get('/signup')

      expect(response.status).to eq(200)
      expect(response.body).to include('Sign Up - Create a new MakersBnB Account')
      expect(response.body).to include('<input name="password" type="password" placeholder="Password" />')
    end

    it 'should return home_page_redirect view due to already being logged in' do
      post("/login", username: "abodian", password: "test" )
      response = get('/signup')
      
      expect(response.status).to eq(200)
      expect(response.body).to include('You are currently logged in therefore cannot sign up. Redirecting to homepage...')
      expect(response.body).to include('<meta http-equiv="refresh" content="3; url = /" />')
    end
  end

  context 'POST /signup' do
    describe "password and repeat password are the same" do
      it 'account is created and account_created view is returned' do
        response =  post('/signup', username: "Spiderman", password: "Web", repeat_password: "Web", first_name: "Peter", last_name: "Parker", email: "webslinger@dailyplanet.net", mobile_number: "696969")

        expect(response.status).to eq(200)
        expect(response.body).to include('Welcome to MakersBnB, Peter')
        user = User.find_by(username: "Spiderman")
        user.destroy
      end
    end
    
    describe "password and repeat password are not the same" do
      it 'account not created and sign_up_password_fail view is returned' do
        response =  post('/signup', username: "Spiderman", password: "Web", repeat_password: "Aunt", first_name: "Peter", last_name: "Parker", email: "webslinger@dailyplanet.net", mobile_number: "696969")

        expect(response.status).to eq(200)
        expect(response.body).to include('Your passwords must match, please try again...')
      end
    end
    
    describe "there is a blank field in the form" do
      it 'account not created and sign_up_blank view is returned' do
        response =  post('/signup', username: "", password: "Web", repeat_password: "Aunt", first_name: "Peter", last_name: "Parker", email: "webslinger@dailyplanet.net", mobile_number: "696969")

        expect(response.status).to eq(200)
        expect(response.body).to include('You cannot leave any of the fields blank, please try again...')
      end
    end

    describe "the username the new user is trying to use is already taken" do
      it 'account not created and username_taken view is returned' do
        response =  post('/signup', username: "abodian", password: "Web", repeat_password: "Web", first_name: "Peter", last_name: "Parker", email: "webslinger@dailyplanet.net", mobile_number: "696969")

        expect(response.status).to eq(200)
        expect(response.body).to include('Sorry, that username is taken...')
      end
    end
  end

  context "get /stays-management" do
    it "lists all pending stay requests for the user" do

    end
  end
end
