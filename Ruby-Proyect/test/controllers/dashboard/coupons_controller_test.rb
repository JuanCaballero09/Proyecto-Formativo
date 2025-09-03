require "test_helper"

class Dashboard::CouponsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get dashboard_coupons_index_url
    assert_response :success
  end

  test "should get show" do
    get dashboard_coupons_show_url
    assert_response :success
  end

  test "should get new" do
    get dashboard_coupons_new_url
    assert_response :success
  end

  test "should get edit" do
    get dashboard_coupons_edit_url
    assert_response :success
  end
end
