require "spec_helper"
require "rack/test"
require_relative '../../app/controllers/application_controller'
require 'json'
require "sinatra/base"
require "sinatra/activerecord"

describe ApplicationController do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { ApplicationController.new }

  # Write your integration tests below.
  # If you want to split your integration tests
  # accross multiple RSpec files (for example, have
  # one test suite for each set of related features),
  # you can duplicate this test file to create a new one.

  context 'GET /signup' do
    it 'should get the signup page as not logged in' do
      response = get('/signup')

      expect(response.status).to eq(200)
      expect(response.body).to include('Sign Up - Create a new MakersBnB Account')
      expect(response.body).to include('<input name="password" type="password" placeholder="Password" />')
    end

    # it 'should return home_page_redirect view due to already being logged in' do
    #   post("/login", username: "abodian", password: "test" )
    #   response = get('/signup')
      
    #   expect(response.status).to eq(200)
    #   expect(response.body).to include('You are currently logged in therefore cannot sign up. Redirecting to homepage...')
    #   expect(response.body).to include('<meta http-equiv="refresh" content="2; url = /" />')
    # end
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
  end
end
