class CreateStages < ActiveRecord::Migration[5.1]
  def change
    create_table :stages do |t|
      t.string :name, :null => true
      t.integer :owner_id, :null => false
      t.timestamp :deleted_at, :index => true
      t.string :slug, :index => true, :null => false

      t.timestamps
    end

    add_foreign_key :stages, :users, :column => :owner_id
    add_index :stages, [ :deleted_at, :slug ], :unique => true
  end
end
