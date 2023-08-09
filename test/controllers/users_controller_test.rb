require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:paco)
  end

  test "should get index" do
    get user_url(@user.username)
    assert_response :success 
  end
end
