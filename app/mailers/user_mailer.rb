class UserMailer < ApplicationMailer
  def confirm_email(user)
    @user = user
    mail( to: @user.email, subject: "Please Confirm Your Email Address" )
  end
end
