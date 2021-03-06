class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:edit, :update, :show]
  before_filter :when_signed_in, only: [:new, :create]
  before_filter :correct_user, only: [:edit, :update, :show]
  before_filter :admin_user, only: [:index, :destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Mathoscope!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user_to_kill = User.find(params[:id])
    if !current_user?(@user_to_kill)
      @user_to_kill.destroy
      flash[:success] = "User destroyed."
    else
      flash[:error] = "You can't destroy yourself"
    end
    redirect_to users_path
  end


  private

    def when_signed_in
      redirect_to root_path if signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      unless current_user?(@user) || current_user.admin?
        redirect_to(root_path)
      end
    end

end
