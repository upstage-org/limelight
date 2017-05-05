class CreateSoundTags < ActiveRecord::Migration[5.1]
  def change
    create_table :sound_tags do |t|
      t.belongs_to :sound, foreign_key: true, null: false
      t.belongs_to :tag, foreign_key: true, null: false

      t.timestamps
    end
    add_index :sound_tags, [ :sound_id, :tag_id ], :unique => true
  end
end
