class StageMedium < ApplicationRecord
  belongs_to :stage
  belongs_to :medium

  validates :stage, :presence => true
  validates :medium, :presence => true
end
