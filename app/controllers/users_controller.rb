class UsersController < ApplicationController
  before_action :reject_anonymous, :except => [ :new, :create, :confirm_email ]
  before_action :set_user, :except => [ :index, :new, :create, :confirm_email ]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(new_user_params)
    if @user.save
      UserMailer.confirm_email(@user).deliver_now
      if current_user
        flash[:success] = "User created"
        redirect_to edit_user_path(@user)
      else
        flash[:success] = "Registration complete. You will be notified once your account has been activated, please check your email to confirm your address"
        redirect_to root_path
      end
    else
      flash.now[:danger] = "Something went wrong"
      render :new
    end
  end

  def show
    unless @user.is_active?
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def edit
  end

  def update
    if @user.update(update_user_params)
      flash[:success] = "User updated"
      if @user.is_active?
        redirect_to @user
      else
        redirect_to users_path
      end
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

  def confirm_email
    @user = User.find_by_confirmation_token!(params[:confirmation_token])
    @user.email_confirmed = Time.zone.now
    if @user.save
      flash[:success] = "Thank you, your email address has been confirmed"
    else
      flash[:danger] = "Something went wrong"
    end
    redirect_to root_path
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
