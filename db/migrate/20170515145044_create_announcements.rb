class CreateAnnouncements < ActiveRecord::Migration[5.1]
  def change
    create_table :announcements do |t|
      t.string :title, null: false
      t.string :subtitle
      t.text :body, null: false
      t.belongs_to :user, null: false, foreign_key: true
      t.string :slug, null: false, index: true
      t.datetime :deleted_at, index: true

      t.timestamps null: false
    end

    add_index :announcements, [:slug, :deleted_at], unique: true
  end
end
