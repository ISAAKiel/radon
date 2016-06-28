module UserHelper
  
  def login(a)
    visit root_path
    fill_in 'user_session[login]', with: a.login
    fill_in 'user_session[password]', with: a.password
    click_button 'Sign in'
  end
  
  def logout(a)
    visit root_path
    click_link 'Log Out'
  end
end
