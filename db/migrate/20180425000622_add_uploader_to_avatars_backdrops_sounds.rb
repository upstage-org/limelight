class AddUploaderToAvatarsBackdropsSounds < ActiveRecord::Migration[5.1]
  def change
    add_reference :avatars, :uploader, foreign_key: true, null: false, default: 1
    add_foreign_key :avatars, :users, :column => :uploader_id
    add_reference :backdrops, :uploader, foreign_key: true, null: false, default: 1
    add_foreign_key :backdrops, :users, :column => :uploader_id
    add_reference :sounds, :uploader, foreign_key: true, null: false, default: 1
    add_foreign_key :sounds, :users, :column => :uploader_id
  end
end
