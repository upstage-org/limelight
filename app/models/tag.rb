class Tag < ApplicationRecord
  before_validation :standardize_name

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
