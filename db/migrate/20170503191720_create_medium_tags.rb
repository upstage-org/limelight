class CreateMediumTags < ActiveRecord::Migration[5.1]
  def change
    create_table :medium_tags do |t|
      t.belongs_to :medium, foreign_key: true
      t.belongs_to :tag, foreign_key: true

      t.timestamps
    end
    add_index :medium_tags, [ :medium_id, :tag_id ], :unique => true
  end
end
