class AudioChannel < ApplicationCable::Channel
	def subscribed
    	@stage = Stage.find_by_slug!(params[:slug])
    	@audio_allocation = @stage.sounds.map { |au| [au.source, nil] }.to_h
    	stream_for @stage
    end

    def play(data)
    	unless current_user.nil? || @audio_allocation[data['audio_id']] != nil
    		@audio_allocation[data['audio_id']] = current_user
    		AudioChannel.broadcast_to @stage, { action: 'play', audio_id: data["audio_id"] }
    	end
  	end
end
