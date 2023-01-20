require 'spec_helper'
require 'rack/test'
require_relative '../../app/controllers/application_controller'
require 'json'
require 'sinatra/base'
require 'sinatra/activerecord'
require 'bcrypt'

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

    it 'includes a link to your account page after logging in' do
      post 'login', { username: 'abodian', password: 'test' }
      response = get('/')
      expect(response.status).to eq(200)
      expect(response.body).to include("<div><a href='/myaccount'>My account</a></div>")
    end
  end

  context 'POST to /login' do
    it 'logs in with valid credentials' do
      response = post('/login', username: 'abodian', password: 'test')
      expect(last_response.status).to eq(200)
      expect(response.body).to include 'Logged In Successfully!'
    end

    it 'remains logged in when navigating site' do
      post '/login', { username: 'abodian', password: 'test' }
      response = get('/')
      expect(response.body).to include 'You are logged in as:'
    end

    it 'will not signin with invalid credentials' do
      response = post('/login', username: 'abodian', password: 'wrong')
      expect(response.status).to eq(200)
      expect(response.body).not_to include 'You are logged in as:'
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
      expect(response.body).to include('<div class="topnav">')
      expect(response.body).to include('Sign Up - Create a new MakersBnB Account')
      expect(response.body).to include('<input name="password" type="password" placeholder="Password" />')
    end

    it 'should return home_page_redirect view due to already being logged in' do
      post('/login', username: 'abodian', password: 'test')
      response = get('/signup')

      expect(response.status).to eq(200)
      expect(response.body).to include('You are currently logged in therefore cannot sign up. Redirecting to homepage...')
      expect(response.body).to include('<meta http-equiv="refresh" content="3; url = /" />')
    end
  end

  context 'POST /signup' do
    describe 'password and repeat password are the same' do
      it 'account is created and account_created view is returned' do
        response = post('/signup', username: 'Spiderman', password: 'Web', repeat_password: 'Web',
                                   first_name: 'Peter', last_name: 'Parker', email: 'webslinger@dailyplanet.net', mobile_number: '696969')

        expect(response.status).to eq(200)
        expect(response.body).to include('Welcome to MakersBnB, Peter')
        user = User.find_by(username: 'Spiderman')
        user.destroy
      end
    end

    describe 'password and repeat password are not the same' do
      it 'account not created and sign_up_password_fail view is returned' do
        response = post('/signup', username: 'Spiderman', password: 'Web', repeat_password: 'Aunt',
                                   first_name: 'Peter', last_name: 'Parker', email: 'webslinger@dailyplanet.net', mobile_number: '696969')

        expect(response.status).to eq(200)
        expect(response.body).to include('<div class="topnav">')
        expect(response.body).to include('Your passwords must match, please try again...')
      end
    end

    describe 'there is a blank field in the form' do
      it 'account not created and sign_up_blank view is returned' do
        response = post('/signup', username: '', password: 'Web', repeat_password: 'Aunt', first_name: 'Peter',
                                   last_name: 'Parker', email: 'webslinger@dailyplanet.net', mobile_number: '696969')

        expect(response.status).to eq(200)
        expect(response.body).to include('<div class="topnav">')
        expect(response.body).to include('You cannot leave any of the fields blank, please try again...')
      end
    end

    describe 'the username the new user is trying to use is already taken' do
      it 'account not created and username_taken view is returned' do
        response = post('/signup', username: 'abodian', password: 'Web', repeat_password: 'Web', first_name: 'Peter',
                                   last_name: 'Parker', email: 'webslinger@dailyplanet.net', mobile_number: '696969')

        expect(response.status).to eq(200)
        expect(response.body).to include('  <div class="topnav">')
        expect(response.body).to include('Sorry, that username is taken...')
      end
    end
  end

  context 'GET to /myaccount' do
    it 'directs to the correct account page with correct details' do
      post '/login', { username: 'abodian', password: 'test' }
      response = get('/myaccount')
      expect(response.status).to eq 200
      expect(response.body).to include 'Account page for Alex Bodian'
      expect(response.body).to include 'abodian'
      expect(response.body).to include 'abodian@email.com'
      expect(response.body).to include '+44714241945'
    end

    it 'includes links to home, stays management and rentals management ' do
      post '/login', { username: 'abodian', password: 'test' }
      response = get('/myaccount')
      expect(response.body).to include "<a href= '/'>"
      expect(response.body).to include "<a href= '/stays-management'>"
      expect(response.body).to include "<a href= '/rentals-management'>"
      expect(response.body).to include "<a href= '/myaccount-update'>"
    end
  end

  context 'GET to myaccount-update' do
    it 'returns account page with correct details and an update form' do
      post '/login', { username: 'abodian', password: 'test' }
      response = get('/myaccount-update')
      expect(response.status).to eq 200
      expect(response.body).to include 'Account page for Alex Bodian'
      expect(response.body).to include 'abodian'
      expect(response.body).to include 'abodian@email.com'
      expect(response.body).to include '+44714241945'
      expect(response.body).to include('<input name="password" type="password" placeholder="Password" />')
      expect(response.body).to include('<input type="submit" value="Update Details" />')
      expect(response.body).to include('<p><input name="username" value="abodian" /></p>')
      expect(response.body).to include('<p><input name="first_name" value="Alex" /></p>')
    end
  end

  context 'POST to myaccount-update' do
    describe 'password and repeat password match' do
      it 'updates the details of an existing user' do
        post('/signup', username: 'Spiderman', password: 'Web', repeat_password: 'Web', first_name: 'Peter',
                        last_name: 'Parker', email: 'webslinger@dailyplanet.net', mobile_number: '696969')
        response = post('/myaccount-update', username: 'testchange', password: 'WebX', repeat_password: 'WebX',
                                             first_name: 'PeterX', last_name: 'ParkerX', email: 'webslinger@dailyplanet.netX', mobile_number: '696969X')

        expect(response.status).to eq(200)
        expect(response.body).to include('Your details have been updated')
        user = User.find_by(username: 'testchange')
        expect(user.username).to eq 'testchange'
        expect(user.first_name).to eq 'PeterX'
        expect(user.last_name).to eq 'ParkerX'
        expect(user.email).to eq 'webslinger@dailyplanet.netX'
        expect(user.mobile_number).to eq '696969X'
        user.destroy
      end
    end

    describe 'password and repeat password do not match' do
      it 'it lets user know their passwords do not match and redirects back to update details page' do
        post('/signup', username: 'Spiderman', password: 'Web', repeat_password: 'Web', first_name: 'Peter',
                        last_name: 'Parker', email: 'webslinger@dailyplanet.net', mobile_number: '696969')
        response = post('/myaccount-update', username: 'testchange', password: 'WebX', repeat_password: 'Web',
                                             first_name: 'PeterX', last_name: 'ParkerX', email: 'webslinger@dailyplanet.netX', mobile_number: '696969X')

        expect(response.status).to eq(200)
        expect(response.body).to include('<p><span style="color:red">Your passwords do not match, please try again.</span></p>')
        user = User.find_by(username: 'Spiderman')
        user.destroy
      end
    end
  end

  context 'get/space/:id' do
    it 'should get to space page ' do
      response = get('/space/1')

      expect(response.status).to eq(200)
      expect(response.body).to include('    <div class="topnav">')
      expect(response.body).to include('Description')
    end
  end

  context 'get /space/book/:id' do
    it 'should show a list of available dates and allow user to submit a choice' do
      response = get('/space/book/1')

      expect(response.status).to eq(200)
      expect(response.body).to include(' <div class="topnav">')
      expect(response.body).to include('      <option value="2028-01-23 00:00:00 UTC">23-01-2028</option>')
    end
  end

  context 'POST /space/book/:id' do
    it 'sends request to book specific space  if user is logged in' do
      post('/login', username: 'abodian', password: 'test')
      response = post('/space/book/1', stay_date: '2028-01-23', request_time: '19-01-2023', request_approval: '1',
                                       space_id: '1', user_id: '1')

      expect(response.status).to eq(200)
      expect(response.body).to include('<title>Booking confirmation</title>')

      booking = Booking.find_by(stay_date: '2028-01-23')
      expect(booking.request_time).to eq('2023-01-19 00:00:00 UTC')
      booking.destroy
    end
  end

  context 'get /stays-management' do
    it 'lists all pending stay requests for the user' do
      post('/login', username: 'abodian', password: 'test')
      response = get('/stays-management')

      expect(response.status).to eq(200)
      expect(response.body).to include('<div class="topnav">')
      expect(response.body).to include('<h1>Your Pending Stay Requests:</h1>')
      expect(response.body).to include('<h2>Space Name: Lovely Cottage</h2>')
    end
  end

  context 'POST /stays-management' do
    it 'deletes a booking request if pending or approved' do
      post('/login', username: 'abodian', password: 'test')
      post('/space/book/1', stay_date: '2028-01-23', request_time: '19-01-2023', request_approval: '1', space_id: '1',
                            user_id: '1')
      booking = Booking.find_by(stay_date: '2028-01-23')
      response = post("/stays-management/delete/#{booking.id}")

      expect(response.status).to eq(200)
      expect(response.body).to include('<p>Your booking has been deleted...taking you back to your Stays Management page</p>')
      expect(response.body).to include('<meta http-equiv="refresh" content="3; url = /stays-management" />')
      expect(Booking.all.length).to eq 23
    end
  end

  context 'GET /rentals-management' do
    it 'returns list of users owned spaces IF logged in' do
      post '/login', { username: 'abodian', password: 'test' }
      response = get('/rentals-management')
      expect(response.status).to eq(200)
      expect(response.body).to include('Your rentals:')
      expect(response.body).to include('Lovely Cottage')
    end

    it 'redirects to homepage IF NOT logged in' do
      get('/rentals-management')
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include('<meta http-equiv="refresh" content="3; url = /" />')
    end
  end

  context 'POST /bookings/:id/update' do
    describe 'user is logged in' do
      it 'updates the booking status from pending to approved (1 to 2) in the database' do
        post('/login', username: 'abodian', password: 'test')
        response = post('bookings/1/update', request_approval: 2)
        expect(response.status).to eq(302)
        booking = Booking.find('1')
        expect(booking.request_approval).to eq '2'
        post('bookings/1/update', request_approval: 1)
      end
    end

    describe 'user is not logged in' do
      it 'updates the booking status from pending to approved (1 to 2) in the database' do
        response = post('bookings/1/update', request_approval: 2)
        expect(response.status).to eq(200)
        expect(response.body).to include('<p>You are not authorised to perform this action. Redirecting to homepage</p>')
      end
    end

    context 'get to /rentals/add' do
      it 'provides a form for the user to add a new rental' do
        response = get('/rentals/add')
        expect(response.status).to eq 200
        expect(response.body).to include '<h1>Add a new rental:</h1>'
        expect(response.body).to include '<form action="/rentals/add" method="POST">'
      end
    end

    context 'POST to /rentals/add' do
      describe 'all fields are properly filled out' do
        it 'adds a new rental to the spaces list' do
          post '/login', { username: 'abodian', password: 'test' }
          response = post('/rentals/add', name: 'New Cottage', description: 'A lovely new place', price: 100,
                                          address: '123 Made Up Street')
          expect(response.status).to eq(200)
          expect(response.body).to include '<h2>Your new rental has now been listed on MakersBnB</h2>'
          space = Space.find_by(name: 'New Cottage')
          expect(space.name).to eq 'New Cottage'
          expect(space.description).to eq 'A lovely new place'
          expect(space.price.to_f).to eq 100.0
          expect(space.address).to eq '123 Made Up Street'
          space.destroy
        end
      end
    end
  end
end
