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
end
