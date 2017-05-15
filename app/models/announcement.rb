class Announcement < ApplicationRecord
  extend FriendlyId
  acts_as_paranoid
  friendly_id :title, :use => [ :slugged, :finders ]

  belongs_to :user
  alias_attribute :author, :user

  validates :title, :presence => true
  validates :body, :presence => true
  validates :author, :presence => true
end
