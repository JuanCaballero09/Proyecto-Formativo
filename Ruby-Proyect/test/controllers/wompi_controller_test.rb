require "test_helper"

class WompiControllerTest < ActionDispatch::IntegrationTest
  test "should get webhook" do
    get wompi_webhook_url
    assert_response :success
  end
end
