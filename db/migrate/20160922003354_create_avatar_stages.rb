class CreateAvatarStages < ActiveRecord::Migration[5.0]
  def change
    create_table :avatar_stages do |t|
      t.belongs_to :stage, foreign_key: true
      t.belongs_to :avatar, foreign_key: true

      t.timestamps
    end
  end
end
