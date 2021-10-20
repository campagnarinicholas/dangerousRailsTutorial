require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end 
  
  test "login with invalid information" do
    get login_path # visit login path
    assert_template 'sessions/new' # verify new sessions form renders
    post login_path, params: { session: { email: "", password: "" } } # post invalid login
    assert_template 'sessions/new' # verify new sessions form renders
    assert_not flash.empty? # veryify flash message appears
    get root_path # go to another root path
    assert flash.empty? # verify flashmessage is gone 
  end
  
  test "login with valid information followed by logout" do
    get login_path 
    post login_path, params: { session: { email: @user.email,
                                          password: 'password' } }
    assert is_logged_in?
    assert_redirected_to @user 
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url 
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
end
