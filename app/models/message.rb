class Message < ApplicationRecord

  MODIFIERS = { :shout => '!' }

  belongs_to :sender, :class_name => 'User'
  belongs_to :stage

  validates :content, :presence => true, :length => {minimum: 1, maximum: 1000}

  after_create_commit { MessageBroadcastJob.perform_later(self) }

  def is_shouted?
    self.content.starts_with? MODIFIERS[:shout]
  end

  def formatted_content
    msg = self.content
    if MODIFIERS.map { |m, v| v }.include? msg[0]
      msg[0] = ''
    end
    return msg
  end
end
