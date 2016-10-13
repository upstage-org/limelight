require 'test_helper'
require 'message'

class MessageTest < ActiveSupport::TestCase
  test "should not save message without content" do
    message = Message.new
    assert_not message.save, "Saved the message without a content"
  end

  test "find content" do
    assert_equal "Hi, This is for testing!", messages(:one).content
  end
  
  test "find the content with stage_id" do
    assert_equal "Hi, this is solely for testing!", Message.where(stage_id: 3).take.content
  end
  
  test "find the user_id of the message" do
    assert_equal "1", messages(:one).user_id
  end
  
end

