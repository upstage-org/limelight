class MoveSoundsToPaperclip < ActiveRecord::Migration[5.1]
  def up
    add_attachment :sounds, :source
    remove_belongs_to :sounds, :medium, :foreign_key => true
  end

  def down
    remove_attachment :sounds, :source
    add_belongs_to :sounds, :medium, :foreign_key => true
  end
end
