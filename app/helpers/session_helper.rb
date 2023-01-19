module SessionHelper
  def logged_in?
    !!session[:user_id]
  end

  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end

  def log_in
    user = User.find_by(username: params[:username])
    return false if user.nil?
    return false unless BCrypt::Password.new(user.password_digest) == params[:password]

    session[:user_id] = user.id
    true
  end

  def sign_up_field_empty?
    params[:username].empty? ||
      params[:email].empty? ||
      params[:password].empty? ||
      params[:repeat_password].empty? ||
      params[:first_name].empty? ||
      params[:last_name].empty? ||
      params[:mobile_number].empty?
  end

  def password_and_repeat_password_match
    params[:password] == params[:repeat_password]
  end

  def username_not_available
    User.find_by(username: params[:username])
  end

  def create_user_and_login
    @user = User.create(username: params[:username], email: params[:email],
                        password: params[:password], first_name: params[:first_name], last_name: params[:last_name])

    session[:user_id] = @user.id
  end

  def load_homepage
    @spaces = Space.all
    erb(:index)
  end

  def load_space
    @space = Space.find_by(id: params[:id])
    @dates = SpaceDate.where(space_id: params[:id]).order('date_available ASC')
  end

  def book_space_date_choice
    @space = Space.find(params[:id])
    @dates = SpaceDate.where(space_id: params[:id]).select(:date_available).distinct.pluck(:date_available)
  end

  def create_new_booking
    @booking = Booking.create(stay_date: params[:stay_date], request_time: params[:request_time], 
      space_id: params[:space_id], user_id: params[:user_id], request_approval: '1')
  end

  def stays_approval_status
    @user_pending_stays = Booking.where(user_id: current_user.id, request_approval: 1)
    @user_approved_stays = Booking.where(user_id: current_user.id, request_approval: 2)
    @user_declined_stays = Booking.where(user_id: current_user.id, request_approval: 3)
    @user_previous_stays = Booking.where(user_id: current_user.id, stay_date: Time.now.midnight-1.day..Time.now.midnight)
  end


end
