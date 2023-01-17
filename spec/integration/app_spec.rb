require 'spec_helper'
require 'rack/test'
require_relative '../../app/controllers/application_controller'
require 'json'

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
      expect(last_response.body).to include 'You are logged in as'
    end

    it 'will not signin with invalid credentials' do
      response = post('/login', username: 'abodian', password: 'wrong')
      expect(response.body).not_to include 'You are logged in as'
    end
  end

  context 'GET to /logout' do
    it 'removes session variables' do
      post '/signin', { username: 'abodian', password: 'test' }
      response = get('/logout')
      expect(session[:user_id]).to eq nil
    end
  end
end
