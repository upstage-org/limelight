class RemoveMediumFromBackdrops < ActiveRecord::Migration[5.1]
  def up
    remove_belongs_to :backdrops, :medium, foreign_key: true
  end

  def down
    add_belongs_to :backdrops, :medium, foreign_key: true
  end
end
