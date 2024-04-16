require "test_helper"

class ProductControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get product_show_url
    assert_response :success
  end

  test "should get more_deatils" do
    get product_more_deatils_url
    assert_response :success
  end
end
