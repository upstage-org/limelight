class MediumTag < ApplicationRecord
  belongs_to :medium
  belongs_to :tag

  validates :tag, :uniqueness => { :scope => :medium }
end
