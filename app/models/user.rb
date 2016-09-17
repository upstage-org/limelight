class User < ApplicationRecord
  extend FriendlyId

  before_create { generate_token(:auth_token) }
  before_create { generate_token(:confirmation_token) }

  scope :active, -> { where(:is_active => true) }
  scope :inactive, -> { where(:is_active => false) }

  has_secure_password
  acts_as_paranoid

  has_many :user_roles
  has_many :roles, :through => :user_roles

  validates :email, :email => true, :presence => true, :uniqueness => true
  validates :nickname, :presence => true, :length => { minimum: 3 }, :uniqueness => true


  friendly_id :nickname, use: [ :slugged, :finders ]

  private
    def generate_token(column)
      self[column] = SecureRandom.urlsafe_base64
      begin
        self[column] = SecureRandom.urlsafe_base64
      end while User.exists?(column => self[column])
    end
end
