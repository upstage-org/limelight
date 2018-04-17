class SessionsController < ApplicationController
  before_action :reject_anonymous, :except => [ :new, :create ]
  invisible_captcha :only => [ :create ], :honeypot => :bucket

  def new
  end

  def create
    user = User.find_by_email(params[:uid])
    unless EmailValidator.valid?(params[:uid])
      user = User.find_by_username(params[:uid])
    end
    if user && user.authenticate(params[:password])
      if user.is_active
        if user.email_confirmed.nil?
          flash[:danger] = "You have not confirmed your email address"
        else
          if params[:remember_me]
            cookies.permanent[:auth_token] = user.auth_token
          else
            cookies[:auth_token] = user.auth_token
          end
        end
      else
        flash[:danger] = "Your account has not been activated"
      end
      redirect_to root_path
    else
      flash.now[:danger] = "Email or password incorrect"
      render :new
    end
  end

  def destroy
    cookies.delete(:auth_token)
    flash[:success] = "Successfully logged out"
    redirect_to root_url
  end
end
