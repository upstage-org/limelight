require 'test_helper'

class MediaControllerTest < ActionDispatch::IntegrationTest

  setup do
    @media = Medium.create(name: 'testing_media1', owner_id: 1, media_type: 'Image', slug: 'media1', created_at: '2016-09-05 12:37:42', updated_at: '2016-09-09 12:37:42')
    @media.save
  end
  
  teardown do
    Rails.cache.clear
  end
  
  test "should show media" do
    login_as(:Admin)
    get '/media'
    assert_response :success
  end
  
  # test "should destroy media" do
  #   media = media(:one)

  # test "should destroy media" do
  # end
  
  
end
