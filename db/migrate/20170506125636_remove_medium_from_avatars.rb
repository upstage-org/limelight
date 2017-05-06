class RemoveMediumFromAvatars < ActiveRecord::Migration[5.1]
  def up
    remove_belongs_to :avatars, :media, foreign_key: true
    remove_column :avatars, :medium_id
  end

  def down
    add_belongs_to :avatars, :media, foreign_key: true
  end
end
