class CreateBackdropTags < ActiveRecord::Migration[5.1]
  def change
    create_table :backdrop_tags do |t|
      t.belongs_to :backdrop, foreign_key: true, null: false
      t.belongs_to :tag, foreign_key: true, null: false

      t.timestamps
    end
    add_index :backdrop_tags, [ :backdrop_id, :tag_id ], :unique => true
  end
end
