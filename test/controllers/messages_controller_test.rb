require 'test_helper'

class MessageControllerTest < ActionDispatch::IntegrationTest
    # called before every single test
    setup do
        @message = messages(:one)
    end
    
    # called after every single test
    teardown do
        
    end
    
    test "should destroy message" do
        assert_difference('Message.count', -1) do
            delete message_url(@message)
        end
        assert_redirected_to messages_path
    end
end
