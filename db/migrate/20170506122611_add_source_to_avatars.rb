class AddSourceToAvatars < ActiveRecord::Migration[5.1]
  def up
    add_attachment :avatars, :source
  end

  def down
    remove_attachment :avatars, :source
  end
end
