class AddPasswordResetToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :password_reset_token, :string, :index => true
    add_column :users, :password_reset_sent_at, :timestamp
  end
end
