class CreateStageTags < ActiveRecord::Migration[5.1]
  def change
    create_table :stage_tags do |t|
      t.belongs_to :stage, foreign_key: true
      t.belongs_to :tag, foreign_key: true

      t.timestamps
    end
    add_index :stage_tags, [ :medium_id, :tag_id ], :unique => true
  end
end
