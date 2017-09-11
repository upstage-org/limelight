class BackdropTag < ApplicationRecord
  belongs_to :backdrop
  belongs_to :tag

  validates :backdrop, :presence => true, :uniqueness => { :scope => :tag_id }
  validates :tag, :presence => true, :uniqueness => { :scope => :backdrop_id }
end
