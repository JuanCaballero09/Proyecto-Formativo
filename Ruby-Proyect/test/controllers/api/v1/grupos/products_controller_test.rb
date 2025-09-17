require "test_helper"

class Api::V1::Grupos::ProductsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_grupos_products_index_url
    assert_response :success
  end

  test "should get show" do
    get api_v1_grupos_products_show_url
    assert_response :success
  end
end
