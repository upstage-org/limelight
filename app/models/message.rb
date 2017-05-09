class Message < ApplicationRecord

  MODIFIERS = { :shout => '!', :thought => ':' }

  belongs_to :sender, :class_name => 'User'
  belongs_to :stage

  validates :content, :presence => true, :length => {minimum: 1, maximum: 1000}

  after_create_commit { MessageBroadcastJob.perform_later(self) }

  def formatted_content
    msg = self.content
    MODIFIERS.each do |n, m|
      if msg.starts_with? m
        msg = msg.sub(m, '')
      end
    end
    return msg
  end

  MODIFIERS.each do |k, v|
    define_method("is_#{k.to_s}?") do
      return self.content.starts_with? v
    end
  end
end
