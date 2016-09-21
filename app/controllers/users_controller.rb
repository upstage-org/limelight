class UsersController < ApplicationController
  before_action :reject_anonymous, :except => [ :new, :create, :confirm_email, :forgot_password, :reset_password ]
  before_action :set_user, :only => [ :show, :edit, :update, :destroy ]
  invisible_captcha :only => [ :create, :forgot_password, :reset_password ], :honeypot => :bucket

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(new_user_params)
    if @user.save
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

  def forgot_password
    if request.method == 'POST'
      @user = User.find_by_email(params[:email])
      @user.request_password_reset if @user
      flash[:success] = "Password reset instructions sent. Check your email."
      redirect_to root_path
    end
  end

  def reset_password
    @user = User.find_by_password_reset_token!(params[:password_reset_token])
    if @user.password_reset_sent_at < 2.hours.ago
      flash[:danger] = "Reset expired. Please try again"
      redirect_to forgotten_password_path
    end
    if request.method == 'POST'
      if @user.update(params.require(:user).permit([ :password, :password_confirmation ]))
        flash[:success] = "Password reset"
        redirect_to root_path
      else
        flash.now[:danger] = "Something went wrong"
      end
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
