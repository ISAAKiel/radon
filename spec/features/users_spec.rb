require 'rails_helper'

  feature 'User Management', %q{
    As the site owner
    I want to provide an user management
    so that I can protect functions and grant access based on roles
  } do

    background do
      @agent = FactoryGirl.create(:user)
      FactoryGirl.create(:page,:name => 'home' )
    end

    scenario 'User log in' do
      login(@agent)
      expect(page).to have_content "Logged in successfully."
    end

    scenario 'User log out' do
      login(@agent)
      logout(@agent)
      expect(page).to have_content "You have been logged out."
    end
end
