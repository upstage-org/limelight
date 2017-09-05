class BackdropTag < ApplicationRecord
  belongs_to :backdrop
  belongs_to :tag

  validates :backdrop, :presence => true, :uniqueness => { :scope => :tag }
  validates :tag, :presence => true, :uniqueness => { :scope => :backdrop }
end
