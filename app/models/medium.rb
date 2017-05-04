class Medium < ApplicationRecord
  extend FriendlyId

  before_validation :do_upload

  acts_as_paranoid

  friendly_id :name, :use => [ :slugged, :finders ]

  belongs_to :owner, :class_name => 'User'

  has_many :stage_media, :dependent => :destroy
  has_many :stages, :through => :stage_media

  has_many :medium_tags, :dependent => :destroy
  has_many :tags, :through => :medium_tags

  scope :images_only, -> { where(:media_type => 'Image') }
  scope :audio_only, -> { where(:media_type => 'Audio') }

  attr_accessor :file

  validates :name, :presence => true
  validates :filename, :presence => true
  validates :owner, :presence => true

  validates :media_type, :inclusion => { in: [ 'Image', 'Audio' ] }

  private
    def do_upload
      self.filename = handle_upload(self.file) if self.file
    end
end
