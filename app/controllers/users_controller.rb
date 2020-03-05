class UsersController < ApplicationController
  include SessionsHelper ##Why do I have to include it?

  before_action :only_logged_in, only: [:edit, :update,:index]
  before_action :only_modify_self, only: [:edit, :update]
  before_action :admin_only, only:[:destroy]

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = 'Welcome to the sample app!!'
      redirect_to user_path @user
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = 'Account updated!!'
      redirect_to user_path @user
    else
      render 'edit'
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'User deleted'
    redirect_to users_url
  end
    

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end
  
  # Before Filters

  # Checks if user is logged in to permit action
  def only_logged_in
    unless logged_in?
      store_location
      flash[:danger] = 'Please log in to perform that action'
      redirect_to login_url
    end
  end

  def only_modify_self
    @user = User.find(params[:id])
    redirect_to root_url unless current_user?(@user)
  end

  def admin_only
    redirect_to root_url unless current_user.admin?
  end
end
