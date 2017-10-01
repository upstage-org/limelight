class CreateStageBackdrops < ActiveRecord::Migration[5.1]
  def change
    create_table :stage_backdrops do |t|
      t.belongs_to :backdrop, foreign_key: true
      t.belongs_to :stage, foreign_key: true

      t.timestamps
    end
  end
end
