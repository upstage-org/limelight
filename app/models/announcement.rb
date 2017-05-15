class Announcement < ApplicationRecord
  extend FriendlyId
  acts_as_paranoid
  friendly_id :title, :use => [ :slugged, :finders ]
  after_save :send_email

  belongs_to :user
  alias_attribute :author, :user

  validates :title, :presence => true
  validates :body, :presence => true
  validates :author, :presence => true

  private
    def send_email
      User.all.each do |u|
        SubscriptionsMailer.make_announcement(self, u).deliver_later
      end
    end
end
