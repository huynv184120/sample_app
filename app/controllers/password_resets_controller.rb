class PasswordResetsController < ApplicationController
  before_action :get_user, :valid_user, :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      handle_create @user
    else
      flash.now[:danger] = t(".notfound")
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add :password, t("cant_empty")
      render :edit
    elsif @user.update user_params
      handle_update @user
    else
      flash[:warning] = t(".reset_failer")
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user
    return if @user = User.find_by(email: params[:email])

    flash[:danger] = t(".user_not_exist")
  end

  def valid_user
    return if @user&.activated? && @user&.authenticated?(:reset, params[:id])

    redirect_to root_path
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t(".password_expried")
    redirect_to new_password_reset_path
  end

  def handle_create user
    user.create_reset_digest
    user.send_password_reset_email
    flash[:info] = t(".instructions")
    redirect_to root_path
  end

  def handle_update user
    log_in user
    user.update_attribute :reset_digest, nil
    flash[:success] = t(".reset_success")
    redirect_to user
  end
end
