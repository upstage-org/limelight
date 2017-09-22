class BackdropChannel < ApplicationCable::Channel
  def subscribed
    @stage = Stage.find_by_slug!(params[:slug])
    puts("add backdrop allocation")
    puts(@backdrop_allocation)
    stream_for @stage
  end

  def display(data)
    puts("going in show")
    unless current_user.nil?
      backdrop = Backdrop.find_by_id!(data['backdrop_id'])
      puts(Backdrop.all)
      BackdropChannel.broadcast_to @stage, {
        action: 'display',
        backdrop_id: data["backdrop_id"],
        file: backdrop.source.url(:original)
      }
    end
    puts("ending show")
  end
end
