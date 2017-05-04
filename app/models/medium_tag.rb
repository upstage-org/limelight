class MediumTag < ApplicationRecord
  belongs_to :medium
  belongs_to :tag

  validates_uniqueness_of [ :medium, :tag ]
end
