class Tag < ApplicationRecord
  extend FriendlyId

  acts_as_paranoid
  friendly_id :name, :use => [ :slugged, :finders ]

  validates :name, :presence => true, :uniqueness => true
end
