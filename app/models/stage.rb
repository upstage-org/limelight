class Stage < ApplicationRecord
  extend FriendlyId
  acts_as_paranoid

  belongs_to :owner, :class_name => 'User'
  has_many :stage_media
  has_and_belongs_to_many :media, :through => :stage_media

  friendly_id :name, :use => [ :slugged, :finders ]

  validates :name, :presence => true
  validates :owner, :presence => true
end
