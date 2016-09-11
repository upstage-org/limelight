class CreateRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :roles do |t|
      t.string :name, :null => false
      t.string :slug, :null => false, :index => true, :unique => true

      t.timestamp :deleted_at, :index => true
      t.timestamps
    end

    add_index :roles, [ :name, :deleted_at ], :unique => true
  end
end
