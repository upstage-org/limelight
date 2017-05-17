class CreateStageSounds < ActiveRecord::Migration[5.1]
  def change
    create_table :stage_sounds do |t|
      t.belongs_to :stage, foreign_key: true
      t.belongs_to :sound, foreign_key: true

      t.timestamps
    end
  end
end
