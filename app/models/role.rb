class Role < ApplicationRecord
  extend FriendlyId

  acts_as_paranoid

  has_many :user_roles
  has_many :users, :through => :user_roles

  friendly_id :name, :use => [ :slugged, :finders ]

  validates :name, :presence => true
end
