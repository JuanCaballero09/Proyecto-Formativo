require "test_helper"

class Dashboard::UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get dashboard_users_index_url
    assert_response :success
  end
end
