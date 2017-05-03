class CreateTags < ActiveRecord::Migration[5.1]
  def change
    create_table :tags do |t|
      t.string :name, :null => false, :index => true, :unique => true
      t.string :slug, :null => false, :index => true, :unique => true

      t.timestamps :null => false
      t.timestamp :deleted_at, :index => true
    end
    add_index :tags, [ :name, :deleted_at ], :unique => true
  end
end
