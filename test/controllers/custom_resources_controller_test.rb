require "test_helper"

class CustomResourcesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get custom_resources_new_url
    assert_response :success
  end

  test "should get create" do
    get custom_resources_create_url
    assert_response :success
  end

  test "should get edit" do
    get custom_resources_edit_url
    assert_response :success
  end

  test "should get update" do
    get custom_resources_update_url
    assert_response :success
  end

  test "should get destroy" do
    get custom_resources_destroy_url
    assert_response :success
  end
end
