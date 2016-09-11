class Medium < ApplicationRecord
  extend FriendlyId

  before_validation :do_upload

  acts_as_paranoid

  friendly_id :name, :use => [ :slugged, :finders ]

  belongs_to :owner, :class_name => 'User'
  has_many :stage_media
  has_and_belongs_to_many :media, :through => :stage_media

  attr_accessor :file

  validates :name, :presence => true
  validates :filename, :presence => true
  validates :owner, :presence => true

  validates :media_type, :inclusion => { in: [ 'Image', 'Audio' ] }

  private
    def do_upload
      self.filename = handle_upload(self.file)
    end
end
