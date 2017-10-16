class BackdropChannel < ApplicationCable::Channel
  def subscribed
    @stage = Stage.find_by_slug!(params[:slug])
    stream_for @stage
  end

  def display(data)
    unless current_user.nil?
      backdrop = Backdrop.find_by_id!(data['backdrop_id'])
      BackdropChannel.broadcast_to @stage, {
        action: 'display',
        backdrop_id: data["backdrop_id"],
        file: backdrop.source.url(:original)
      }
    end
  end
end
