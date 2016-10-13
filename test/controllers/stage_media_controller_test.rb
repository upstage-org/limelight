require 'test_helper'

class StageMediaControllerTest < ActionDispatch::IntegrationTest
  # called before every single test
  setup do
    @stage_media = stage_media(:one)
  end
  
  # called after every single test
  teardown do
    Rails.cache.clear
  end
  
  test "should show stage_media" do
    # Reuse the @stage_medium instance variable from setup
    get stage_media_url(@stage_media)
    assert_response :success
  end
  
  test "should destroy stage_media" do
    assert_difference('StageMedium.count', -1) do
      destroy stage_media_url(@stage_media)
    end
    assert_redirected_to stage_media_path
  end
  
end
