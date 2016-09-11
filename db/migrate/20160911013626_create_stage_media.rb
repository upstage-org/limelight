class CreateStageMedia < ActiveRecord::Migration[5.0]
  def change
    create_table :stage_media do |t|
      t.belongs_to :stage, foreign_key: true
      t.belongs_to :medium, foreign_key: true

      t.timestamps
    end
  end
end
