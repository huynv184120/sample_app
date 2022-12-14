class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticated? :password, params[:session][:password]
      handle_authenticated user
    else
      flash.now[:danger] = t(".invalid_pass_or_email")
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  private

  def handle_login user
    log_in user
    if params[:session][:remeber_me] == "1"
      remember user
    else
      forget user
    end
    redirect_back_or user
  end

  def handle_authenticated user
    if user.activated?
      handle_login user
    else
      flash.now[:warning] = t(".account_not_active")
      render :new
    end
  end
end
