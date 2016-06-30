module UserHelper
  
  def login(a)
    visit login_path
    assert_text "Login"
    fill_in 'login_page_login_field', with: a.login
    fill_in 'login_page_password_field', with: a.password
    click_button 'Submit'
    assert_text "Logged in successfully"
  end
  
  def logout(a)
    visit logout_path
    assert_text "You have been logged out."
#    click_link 'Log Out'
  end
end
