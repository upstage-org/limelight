class MessageBroadcastJob < ApplicationJob
    queue_as :default
    
    def perform(content)
        ActionCable.server.broadcast "chat_channel#{content.stage_id}", render_message(content)
    end
    
    private
    def render_message(message)
        MessagesController.render partial: 'messages/message', locals: {message: message}
    end
end
