require "test_helper"

class CustmersControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get custmers_show_url
    assert_response :success
  end
end
