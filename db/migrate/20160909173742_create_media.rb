class CreateMedia < ActiveRecord::Migration[5.0]
  def change
    create_table :media do |t|
      t.string :name, :null => false
      t.integer :owner_id, :null => false
      t.string :media_type, :null => false
      t.timestamp :deleted_at, :index => true
      t.string :slug, :null => false
      t.string :filename, :null => false

      t.timestamps
    end

    add_foreign_key :media, :users, :column => :owner_id
    add_index :media, [ :slug, :deleted_at ], :unique => true
  end
end
