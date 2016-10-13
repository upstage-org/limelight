require 'test_helper'

class MediumTest < ActiveSupport::TestCase
  test "should not save media without name" do
    media = Medium.create
    assert_not media.save, "Saved the media without a content"
  end

  test "find media name" do
    assert_equal "testing_media1", media(:one).name
  end
  
  test "find the filename by owner_id" do
    assert_equal "important_media_test2", Medium.where(owner_id: 1).take.filename
  end
  
  test "find the owner_id of the media" do
    assert_equal 1, media(:one).owner_id
  end
end
