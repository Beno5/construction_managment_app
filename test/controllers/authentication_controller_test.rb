require "test_helper"

class AuthenticationControllerTest < ActionDispatch::IntegrationTest
  test "should get sign_up" do
    get authentication_sign_up_url
    assert_response :success
  end

  test "should get sign_in" do
    get authentication_sign_in_url
    assert_response :success
  end

  test "should get reset_password" do
    get authentication_reset_password_url
    assert_response :success
  end

  test "should get forgot_password" do
    get authentication_forgot_password_url
    assert_response :success
  end

  test "should get profile_lock" do
    get authentication_profile_lock_url
    assert_response :success
  end
end
