class FixMediaIdType < ActiveRecord::Migration[5.1]
  # Rails 5.1 changes id column types from int to bigint - Need to adjust
  def up
    change_column :media, :id, :bigint
    change_column :avatars, :medium_id, :bigint
    change_column :stage_media, :medium_id, :bigint
  end

  def down
    change_column :media, :id, :int
    change_column :avatars, :medium_id, :int
    change_column :stage_media, :medium_id, :int
  end
end
