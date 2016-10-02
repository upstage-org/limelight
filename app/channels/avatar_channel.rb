class AvatarChannel < ApplicationCable::Channel
    def subscribed
        stream_from "avatar_channel#{params[:stage]}"
        
    end
    
    def unsubscribed
    end

end
