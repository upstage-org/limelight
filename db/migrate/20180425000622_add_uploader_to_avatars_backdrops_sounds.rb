class AddUploaderToAvatarsBackdropsSounds < ActiveRecord::Migration[5.1]
  def change
    add_reference :avatars, :uploader
    add_foreign_key :avatars, :users, :column => :uploader_id
    add_reference :backdrops, :uploader
    add_foreign_key :backdrops, :users, :column => :uploader_id
    add_reference :sounds, :uploader
    add_foreign_key :sounds, :users, :column => :uploader_id
  end
end
