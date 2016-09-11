class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def handle_upload(input)
    given = input
    base = given.original_filename.gsub(/[^a-zA-Z\d\-\.]/, '-')
    outname = "#{Time.now.to_i}\_#{base}"
    File.open(Rails.root.join('public', 'uploads', outname), 'wb') do |f|
      f.write(given.read)
    end
    return outname
  end
end
