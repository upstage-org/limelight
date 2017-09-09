class AvatarChannel < ApplicationCable::Channel
  def subscribed
    @stage = Stage.find_by_slug!(params[:slug])
    @avatar_allocation = @stage.avatars.map { |a| [a.id, nil] }.to_h
    stream_for @stage
  end

  def hold(data)
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

  def place(data)
    unless current_user.nil? || @avatar_allocation[data['avatar_id']] != current_user
      avatar = Avatar.find_by_id!(data['avatar_id'])
      AvatarChannel.broadcast_to @stage, {
        action: 'place',
        avatar_id: data['avatar_id'],
        file: avatar.source.url(:original),
        x: data['x'],
        y: data['y']
      }
    end
  end

  def name(data)
    unless current_user.nil? || @avatar_allocation[data['avatar_id']] != nil
      AvatarChannel.broadcast_to @stage, {  
        action: 'name', 
        avatar_name: data['avatar_name']
      }
    end
  end

end
