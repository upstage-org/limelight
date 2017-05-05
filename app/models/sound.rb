class Sound < ApplicationRecord
  extend FriendlyId

  acts_as_paranoid
  belongs_to :medium, :dependent => :destroy

  has_many :sound_tags, :dependent => :destroy
  has_many :tags, :through => :sound_tags

  friendly_id :name, :use => [ :slugged, :finders ]

  accepts_nested_attributes_for :medium

  validates :medium, :presence => true
  validates :name, :presence => true
end
