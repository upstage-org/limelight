class Stage < ApplicationRecord
  extend FriendlyId
  acts_as_paranoid

  belongs_to :owner, :class_name => 'User'
  has_many :stage_media
  has_and_belongs_to_many :media, :through => :stage_media
  has_many :avatar_stages
  has_and_belongs_to_many :avatars, :through => :avatar_stages
  has_many :messages, dependent: :destroy
  

  friendly_id :name, :use => [ :slugged, :finders ]

  validates :name, :presence => true
  validates :owner, :presence => true
end
