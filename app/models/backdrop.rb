class Backdrop < ApplicationRecord
  extend FriendlyId

  acts_as_paranoid

  belongs_to :uploader, :class_name => 'User'

  has_many :stage_backdrops, :dependent => :destroy
  has_many :stages, :through => :stage_backdrops

  has_many :backdrop_tags, :dependent => :destroy
  has_many :tags, :through => :backdrop_tags

  has_attached_file :source, styles: { medium: "300x300>", thumb: "100x100" }, default_url: "/media/:styles/missing.png"

  friendly_id :name, :use => [ :slugged, :finders ]

  validates :name, :presence => true
  validates_attachment_content_type :source, content_type: /\Aimage\/.*\z/
  validates :uploader, :presence => true

  def self.not_assigned(stage)
    self.all.reject { |s| stage.backdrops.include? s }
  end
end
