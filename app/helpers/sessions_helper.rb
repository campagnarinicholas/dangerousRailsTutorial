module SessionsHelper
  
  # Log in given user
  def log_in(user)
    session[:user_id] = user.id # use session like it's a hash associated with user
  end
  
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end
  
  def logged_in?
    !current_user.nil?
  end
  
  def log_out
    session.delete(:user_id) # Delete user_id hash in session
    @current_user = nil
  end
end
