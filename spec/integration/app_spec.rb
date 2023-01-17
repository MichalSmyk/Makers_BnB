require "spec_helper"
require "rack/test"
require_relative '../../app/controllers/application_controller'
require 'json'

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



  context 'get/space/:id' do 
    it 'should get to space page ' do 
      response = get('/space/1') 

      expect(response.status).to eq(200)
      
      expect(response.body).to include('Description')
    end
  end

  context 'POST /space ' do 
    it 'sends request to book specific space ' do 
      response = post('/space')

      expect(response.status).to eq(200)

      # expect(response.body).to eq('')
    end
  end
end
