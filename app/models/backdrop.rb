class Backdrop < ApplicationRecord
  extend FriendlyId

  acts_as_paranoid

  has_many :stage_backdrops, :dependent => :destroy
  has_many :stages, :through => :stage_backdrops

  has_many :backdrop_tags, :dependent => :destroy
  has_many :tags, :through => :backdrop_tags

  has_attached_file :source

  friendly_id :name, :use => [ :slugged, :finders ]

  validates :name, :presence => true
  validates_attachment_content_type :source, content_type: /\Aimage\/.*\z/

  def self.not_assigned(stage)
    selft.all.reject { |s| stage.backdrops.include? s }
  end
end
