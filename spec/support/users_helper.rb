module UserHelper
  
  def login(a)
    visit login_path
    fill_in 'login_page_login_field', with: a.login
    fill_in 'login_page_password_field', with: a.password
    click_button 'Submit'
  end
  
  def logout(a)
    visit logout_path
#    click_link 'Log Out'
  end
end
