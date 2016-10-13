class MessagesController < ApplicationController
    
    def create
        @message = Message.new(message_params)
        @message.user_id = current_user.id
        if @messsage.save
          flash[:success] = "Message created"
        else
          flash.now[:danger] = "Something went wrong"
        end
    end
    
    def destroy
      if @message.destroy
        flash[:success] = "Message removed"
      else
        flash[:danger] = "Something went wrong"
        render @message
      end
    end
    
    def user
        @user = current_user
        return @user.nickname
    end
    
    
  def index
    @message = Message.new
  end
  
  
end