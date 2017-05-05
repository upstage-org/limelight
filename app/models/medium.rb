class Medium < ApplicationRecord
  before_validation :do_upload
  acts_as_paranoid

  attr_accessor :file
  validates :filename, :presence => true

  private
    def do_upload
      self.filename = handle_upload(self.file) if self.file
    end
end
