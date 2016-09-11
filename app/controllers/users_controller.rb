class UsersController < ApplicationController
  before_action :reject_anonymous
  before_action :set_user, except: [ :index, :new, :create ]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(new_user_params)
    if @user.save
      flash[:success] = "User created"
      redirect_to @user
    else
      flash.now[:danger] = "Something went wrong"
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(update_user_params)
      flash[:success] = "User updated"
      redirect_to @user
    else
      flash.now[:danger] = "Something went wrong"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = "User removed"
      redirect_to users_path
    else
      flash[:danger] = "Something went wrong"
      redirect_to @user
    end
  end

  private
    def set_user
      @user = User.find_by_slug!(params[:id])
    end

    def new_user_params
      params.require(:user).permit([ :email, :nickname, :password, :password_confirmation ])
    end

    def update_user_params
      params.require(:user).permit([ :email, :nickname, :is_active ])
    end
end
