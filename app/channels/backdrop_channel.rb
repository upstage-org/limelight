class BackdropChannel < ApplicationCable::Channel
  def subscribed
    @stage = Stage.find_by_slug!(params[:slug])
    @backdrop_allocation = @stage.backdrops.map { |b| [b.source, nil] }.to_h
    puts("add backdrop allocation")
    puts(@backdrop_allocation)
    stream_for @stage
  end

  def show(data)
    puts("going in show")
    unless current_user.nil? || @backdrop_allocation[data['backdrop_id']] !=nil
      @backdrop_allocation[data['backdrop_id']] = current_user
      backdrop = Backdrop.find_by_id!(data['backdrop_id'])
      puts(Backdrop.all)
      BackdropChannel.broadcast_to @stage, {
        action: 'show',
        backdrop_id: data["backdrop_id"]
      }
    end
    puts("ending show")
  end
end
