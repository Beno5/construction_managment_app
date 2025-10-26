require "test_helper"

class UsersSettingsControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get users_settings_edit_url
    assert_response :success
  end

  test "should get update" do
    get users_settings_update_url
    assert_response :success
  end
end
