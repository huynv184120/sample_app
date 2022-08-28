class UsersController < ApplicationController
  before_action :find_user, only: %i(show edit update destroy)
  before_action :logged_in_user, only: %i(index edit update)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: %i(destroy)

  def index
    @pagy, @users = pagy(User.all, page: params[:page],
                         items: Settings.pagy.page_size)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      @user.send_email_activate
      flash[:success] = t(".please_check_mail")
      redirect_to root_path
    else
      flash[:error] = t(".failure")
      render :new
    end
  end

  def show
    @pagy, @microposts = pagy(@user.microposts.newest, page: params[:page],
items: Settings.pagy.page_size)
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = t(".success")
      redirect_to @user
    else
      flash[:error] = t(".failure")
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t(".deleted")
      redirect_to users_url
    else
      flash[:error] = t(".failure")
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  def correct_user
    redirect_to root_url unless current_user?(@user)
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def find_user
    @user = User.find_by(id: params[:id])
    return if @user

    flash[:error] = t(".user_not_exist")
    redirect_to root_path
  end
end
