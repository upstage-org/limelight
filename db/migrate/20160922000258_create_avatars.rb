class CreateAvatars < ActiveRecord::Migration[5.0]
  def change
    create_table :avatars do |t|
      t.string :name, :null => false
      t.belongs_to :medium, foreign_key: true, :null => false
      t.string :slug, :null => false, :index => true
      t.timestamp :deleted_at, :index => true

      t.timestamps
    end
  end
end
