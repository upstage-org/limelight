class AvatarChannel < ApplicationCable::Channel
  def subscribed
    @stage = Stage.find_by_slug!(params[:slug])
    @avatar_allocation = @stage.avatars.map { |a| [a.id, nil] }.to_h
    stream_for @stage
  end

  def hold(data)
    debugger
    unless current_user.nil? || @avatar_allocation[data['avatar_id']] != nil
      @avatar_allocation[data['avatar_id']] = current_user
      AvatarChannel.broadcast_to @stage, { username: current_user.nickname, action: 'hold', avatar_id: data['avatar_id'] }
    end
  end

  def drop(data)
    unless current_user.nil? || @avatar_allocation[data['avatar_id']] != current_user
      @avatar_allocation[data['avatar_id']] = nil
      AvatarChannel.broadcast_to @stage, { action: 'drop', avatar_id: data['avatar_id'] }
    end
  end
end
