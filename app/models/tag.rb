class Tag < ApplicationRecord
  before_validation :standardize_name

  has_many :medium_tags, :dependent => :destroy
  has_many :media, :through => :medium_tags

  has_many :avatars_tags, :dependent => :destroy
  has_many :avatars, :through => :avatar_tags

  has_many :stage_tags, :dependent => :destroy
  has_many :stages, :through => :stage_tags

  has_many :sound_tags, :dependent => :destroy
  has_many :sounds, :through => :sound_tags

  has_many :backdrop_tags, :dependent => :destroy
  has_many :backdrops, :through => :backdrop_tags

  validates :name, :presence => true, :uniqueness => true, :format => /[a-z0-9\-]/, :length => { maximum: 25 }

  def to_param
    self.name
  end

  private
    def standardize_name
      unless self.name.blank?
        self.name = self.name.strip.downcase.gsub(/[^a-z0-9\s\-]/, '').gsub(/\s/, '-')
      end
    end
end
