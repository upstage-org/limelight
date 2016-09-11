class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private
    def current_user
      @current_user ||= User.find_by_auth_token(cookies[:auth_token]) if cookies[:auth_token]
    end
    helper_method :current_user

    def reject_anonymous
      if current_user.nil?
        flash[:warning] = "You must be logged in to do that"
        redirect_to login_url
      end
    end
end
