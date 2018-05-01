class ForceLowercaseUsernames < ActiveRecord::Migration[5.1]
  def change
    User.all.each do |u|
      u.username = u.username.downcase
      u.email = u.email.downcase
      u.save!
    end
  end
end
