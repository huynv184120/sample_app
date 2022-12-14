module SessionsHelper
  def log_in user
    session[:user_id] = user.id
  end

  def current_user
    if user_id = session[:user_id]
      @current_user ||= User.find_by id: session[:user_id] if session[:user_id]
    elsif user_id = cookies.signed[:user_id]
      user = User.find_by(id: user_id)
      if user&.authenticated? :remember, cookies[:remember_token]
        login user
        @current_user = user
      end
    end
  end

  def current_user? user
    user && user == current_user
  end

  def logged_in?
    current_user.present?
  end

  def log_out
    session.delete :user_id
    @current_user = nil
  end

  def remember user
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent.signed[:remember_token] = user.remember_token
  end

  def forget user
    user.forget
    cookies.delete :user_id
    cookies.delete :remember_token
  end

  def redirect_back_or default
    redirect_to(session[:forwarding_ur] || default)
    session.delete(:forwarding_ur)
  end

  def store_location
    session[:forwarding_ur] = request.original_url if request.get?
  end
end
