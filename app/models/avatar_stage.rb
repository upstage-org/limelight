class AvatarStage < ApplicationRecord
  belongs_to :stage
  belongs_to :avatar

  validates :stage, :presence => true
  validates :avatar, :presence => true
end
