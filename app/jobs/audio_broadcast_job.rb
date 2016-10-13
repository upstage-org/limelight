class AudioBroadcastJob < ApplicationJob
    queue_as :default
    
    def perform(data)
        ActionCable.server.broadcast "audio_channel#{data.stage_id}", render_message(content)
    end
    
    private
    def render_message(message)
        StageMediaController.render partial: 'stage_medias/stage_media', locals: {message: message}
    end
end
