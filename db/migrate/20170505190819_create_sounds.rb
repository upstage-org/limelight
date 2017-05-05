class CreateSounds < ActiveRecord::Migration[5.1]
  def change
    create_table :sounds do |t|
      t.string :name, :null => false
      t.belongs_to :medium, foreign_key: true
      t.timestamp :deleted_at, :index => true
      t.string :slug, :index => true

      t.timestamps
    end
    add_index :sounds, [ :slug, :deleted_at ], :unique => true
  end
end
