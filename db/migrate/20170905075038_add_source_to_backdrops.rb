class AddSourceToBackdrops < ActiveRecord::Migration[5.1]
  def up
    add_attachment :backdrops, :source
  end

  def down
    remove_attachment :backdrops, :source
  end
end
