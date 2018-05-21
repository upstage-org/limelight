class AvatarChannel < ApplicationCable::Channel
  def subscribed
    @stage = Stage.find_by_slug!(params[:slug])
    @avatar_allocation = @stage.avatars.map { |a| [a.id, nil] }.to_h
    stream_for @stage
  end

  def hold(data)
    unless current_user.nil? || @avatar_allocation[data['avatar_id']] != nil && @avatar_allocation[data['avatar_id']] != current_user
      @avatar_allocation[data['avatar_id']] = current_user
      avatar = Avatar.find_by_id!(data['avatar_id'])
      AvatarChannel.broadcast_to @stage, {
        username: current_user.id,
        action: 'hold',
        avatar_id: data['avatar_id'],
        file: avatar.source.url(:original),
        name: avatar.name,
        names: data['names'],
        holding: data['holding']
      }
    end
  end

  def speechBubble(data)
    AvatarChannel.broadcast_to @stage, {
      action: 'speechBubble',
      txt: data['txt'],
      avatar_id: data['avatar_id'],
      type: data['type'],
      row: data['row']
    }
  end

  def drop(data)
    unless current_user.nil? || @avatar_allocation[data['avatar_id']] != current_user
      @avatar_allocation[data['avatar_id']] = nil
      AvatarChannel.broadcast_to @stage, { action: 'drop', avatar_id: data['avatar_id'] }
    end
  end

  def editName(data)
    unless current_user.nil? || @avatar_allocation[data['avatar_id']] != current_user
      AvatarChannel.broadcast_to @stage, {
        action: 'editName',
        avatar_id: data['avatar_id'],
        nickname: data['nickname'],
        names: data['names']
      }
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
        y: data['y'],
        name: avatar.name,
        size: data['size'],
        names: data['names']
      }
    end
  end

  def nameToggle(data)
    unless current_user.nil? || @avatar_allocation[data['avatar_id']] != current_user
      AvatarChannel.broadcast_to @stage, {
        action: 'nameToggle',
        avatar_id: data['avatar_id']
      }
    end
  end

  def clearUnheld(data)
      AvatarChannel.broadcast_to @stage, {
        action: 'clearUnheld',
        avatar_id: data['avatar_id']
      }
  end

  def size(data)
    unless current_user.nil? || @avatar_allocation[data['avatar_id']] != current_user
      avatar = Avatar.find_by_id!(data['avatar_id'])
      AvatarChannel.broadcast_to @stage, {
        action: 'size',
        avatar_id: data['avatar_id'],
        value: data['value'],
        file: avatar.source.url(:original)
      }
    end
  end
end
