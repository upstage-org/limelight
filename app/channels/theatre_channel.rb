class TheatreChannel < ApplicationCable::Channel
    def subscribed
        stream_from "theatre_channel#{params[:stage]}"
        
    end
    
    def unsubscribed
    end
    
    def speak(data)
        logger.info  "[ActionCable] received message"
        
        Message.create! content: data['content']['content'], stage_id: data['content']['stage_id'], user_id: data['content']['user_id']
    end
    
    
    
    
    # def render_message(message)
    #   ApplicationController.render(
    #     partial: 'messages/message',
    #     locals: {
    #       message: message,
    #       stage: stage_id,
    #       username: current_user
    #     })
    # end
    
end
