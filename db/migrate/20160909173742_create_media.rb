class CreateMedia < ActiveRecord::Migration[5.1]
  def change
    create_table :media do |t|
      t.timestamp :deleted_at, :index => true
      t.string :filename, :null => false
      t.timestamps
    end
  end
end
