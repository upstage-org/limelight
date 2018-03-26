class ChatChannel < ApplicationCable::Channel
    def subscribed
        stream_from "chat_channel#{params[:stage]}"

    end

    def unsubscribed
    end

    def speak(data)
      logger.info  "[ActionCable] received message"
      Message.create! content: data['content']['content'], stage_id: data['content']['stage_id'], sender_id: data['content']['user_id'], nickname: data['content']['avatarName']
    end

end
