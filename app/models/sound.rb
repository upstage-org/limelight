class Sound < ApplicationRecord
  extend FriendlyId

  acts_as_paranoid
  belongs_to :medium, :dependent => :destroy

  friendly_id :name, :use => [ :slugged, :finders ]

  accepts_nested_attributes_for :medium

  validates :medium, :presence => true
  validates :name, :presence => true
end
