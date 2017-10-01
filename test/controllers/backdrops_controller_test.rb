require 'test_helper'

class BackdropsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get backdrops_new_url
    assert_response :success
  end

  test "should get edit" do
    get backdrops_edit_url
    assert_response :success
  end

  test "should get index" do
    get backdrops_index_url
    assert_response :success
  end

end
