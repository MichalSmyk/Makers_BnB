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
end