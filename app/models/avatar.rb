class Avatar < ApplicationRecord
  extend FriendlyId

  acts_as_paranoid

  belongs_to :uploader, :class_name => 'User'

  has_many :avatar_stages, :dependent => :destroy
  has_many :stages, :through => :avatar_stages

  has_many :avatar_tags, :dependent => :destroy
  has_many :tags, :through => :avatar_tags

  friendly_id :name, :use => [ :slugged, :finders ]

  has_attached_file :source, styles: { medium: "300x300>", thumb: "100x100" }, default_url: "/media/:styles/missing.png"

  validates :name, :presence => true
  validates_attachment_content_type :source, content_type: /\Aimage\/.*\z/
  validates :uploader, :presence => true

  def self.not_assigned(stage)
    self.all.reject { |a| stage.avatars.include? a }
  end

end
