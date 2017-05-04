class CreateAvatarTags < ActiveRecord::Migration[5.1]
  def change
    create_table :avatar_tags do |t|
      t.belongs_to :avatar, foreign_key: true
      t.belongs_to :tag, foreign_key: true

      t.timestamps
    end
  end
end
