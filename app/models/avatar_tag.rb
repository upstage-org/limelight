class AvatarTag < ApplicationRecord
  belongs_to :avatar
  belongs_to :tag

  validates :avatar, :presence => true, :uniqueness => { :scope => :tag_id }
  validates :tag, :presence => true, :uniqueness => { :scope => :avatar_id }
end
