class DialogChannel < ApplicationCable::Channel
  def subscribed
    @stage = Stage.find_by_slug!(params[:slug])
    @avatar_allocation = @stage.avatars.map { |a| [a.id, nil] }.to_h
    stream_for @stage
  end

  def utter(data)
    DialogChannel.broadcast_to @stage, { action: 'utter', dialog: data['dialog'] }
  end
end
