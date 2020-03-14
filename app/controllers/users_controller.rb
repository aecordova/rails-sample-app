class UsersController < ApplicationController

  before_action :only_logged_in, only: %i[edit update index]
  before_action :only_modify_self, only: %i[edit update]
  before_action :admin_only, only: [:destroy]

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    redirect_to root_url && return unless @user.activated?
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = 'Please check your email and activate your account'
      redirect_to root_url
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
    @users = User.where(activated: true).paginate(page: params[:page])
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

  def only_modify_self
    @user = User.find(params[:id])
    redirect_to root_url unless current_user?(@user)
  end

  def admin_only
    redirect_to root_url unless current_user.admin?
  end
end
