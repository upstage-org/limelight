class SoundTag < ApplicationRecord
  belongs_to :sound
  belongs_to :tag

  validates :sound, :presence => true, :uniqueness => { :scope => :tag }
  validates :tag, :presence => true, :uniqueness => { :scope => :sound } 
end
