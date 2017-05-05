class StageTag < ApplicationRecord
  belongs_to :stage
  belongs_to :tag

  validates :stage, :presence => true, :uniqueness => { :scope => :tag }
  validates :tag, :presence => true, :uniqueness => { :scope => :stage }
end
