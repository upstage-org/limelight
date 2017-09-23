class StageBackdrop < ApplicationRecord
  belongs_to :stage
  belongs_to :backdrop

  validates :stage, :presence => true
  validates :backdrop, :presence => true
end
