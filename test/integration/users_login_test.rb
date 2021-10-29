require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
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
    # Simulate a user cliking logout in a second window
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
  
  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_not_empty cookies[:remember_token]
  end 
  
  test "login without remembering" do
    # Log in to set cookie
    log_in_as(@user, remember_me: '1')
    # Log in again and verify the cookie is deleted
    log_in_as(@user, remember_me: '0')
    assert_empty cookies[:remember_token]#, assigns(:user).remember_token
  end
  
  test "should not allow admin attribute to be edited via web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: {
                                    user: {
                                      password: "password",
                                      password_confirmation: "password",
                                      admin: true
                                    }}
    assert_not @other_user.reload.admin?
  end
end
