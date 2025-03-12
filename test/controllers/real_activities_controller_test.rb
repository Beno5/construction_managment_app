require "test_helper"

class RealActivitiesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get real_activities_new_url
    assert_response :success
  end

  test "should get create" do
    get real_activities_create_url
    assert_response :success
  end
end
