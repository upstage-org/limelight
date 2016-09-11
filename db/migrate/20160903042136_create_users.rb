class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :email, :null => false, :index => true, :unique => true
      t.string :password_digest, :null => false
      t.string :auth_token, :null => false
      t.string :nickname, :null => false
      t.boolean :is_active, :null => false, :default => false, :index => true
      t.string :slug, :null => false, :index => true

      t.timestamp :deleted_at, :index => true
      t.timestamps
    end

    add_index :users, [ :deleted_at, :nickname ], :unique => true
  end
end
