class AudioChannel < ApplicationCable::Channel
    def subscribed
        stream_from "audio_channel#{params[:stage]}"
        
    end
    
    def unsubscribed
    end

end
