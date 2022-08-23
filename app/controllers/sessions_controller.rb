class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      log_in user
      if params[:session][:remeber_me] == "1"
        remember user
      else
        forget user
      end
      redirect_to user
    else
      flash.now[:danger] = t(".invalid_pass_or_email")
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
