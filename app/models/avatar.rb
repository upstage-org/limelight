class Avatar < ApplicationRecord
  extend FriendlyId

  acts_as_paranoid

  belongs_to :medium
  has_many :avatar_stages, :dependent => :destroy
  has_many :stages, :through => :avatar_stages

  has_many :avatar_tags, :dependent => :destroy
  has_many :tags, :through => :avatar_tags

  friendly_id :name, :use => [ :slugged, :finders ]

  validates :name, :presence => true
  validates :medium, :presence => true
end
