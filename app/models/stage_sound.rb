class StageSound < ApplicationRecord
  belongs_to :stage
  belongs_to :sound

  validates :stage, :presence => true
  validates :sound, :presence => true
end
