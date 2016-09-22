class Message < ApplicationRecord
  belongs_to :sender, :class_name => 'User'
  belongs_to :stage
  
  validates :content, :presence => true, :length => {minimum: 1, maximum: 1000}
  
  after_create_commit { MessageBroadcastJob.perform_later(self) }
  
  
  
end
