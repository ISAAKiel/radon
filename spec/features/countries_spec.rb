require 'rails_helper'

#save_and_open_page

describe "Countries", :type => :feature do

  before(:each) do
#    FactoryGirl.create(:page,:name => 'home' )
#    FactoryGirl.create(:announcement)
  end

  before(:each, :js=>true) do
    @country = FactoryGirl.create(:country)
  end

  describe "GET /countries" do
    it "displays the countries" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      FactoryGirl.create(:country, :name => 'test_country2')
      FactoryGirl.create(:country, :name => 'test_country1')
      visit countries_path
      expect(page).to have_content("test_country1")
      expect(page).to have_content("test_country2")
    end
  end

  describe "GET /country" do
    it "displays the a country" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      country = FactoryGirl.create(:country_with_country_subdivisions)
      visit countries_path
      find("#country_#{country.id}").click_link 'Show'
      expect(current_path).to eq(country_path(country))
      expect(page).to have_content(country.name) 
    end
  end
  
  describe "Manage Countries" do
    context "not logged in" do
      it "do not display the New link" do
        visit countries_path
        expect(page).not_to have_link('New Country', href: new_country_path)
      end
      
      it "do not display the New form" do
        visit new_country_path
        expect(current_path).not_to eq(new_country_path)
      end

      it "do not display the Edit link" do
        @country = FactoryGirl.create(:country)
        visit countries_path
        expect(page).not_to have_link('Edit', href: edit_country_path(@country))
      end

      it "do not display the Edit form" do
        @country = FactoryGirl.create(:country)
        visit edit_country_path(@country)
        expect(current_path).not_to eq(edit_country_path(@country))
      end

    end
    context "logged in admin_user" do
      it "do display the New link" do
        user = FactoryGirl.create(:admin_user)
        login(user)
        visit countries_path
        expect(page).to have_link('New Country', href: new_country_path)
        logout(user)
      end

      it "Adds a new Country and displays the results" do
        user = FactoryGirl.create(:admin_user)
        country = FactoryGirl.build(:country)
        login(user)
        visit countries_url
        expect{
          click_link 'New Country'
          fill_in 'country_name', with: country.name + "new"
          click_button "Submit"
        }.to change(Country,:count).by(1)
        expect(page).to have_content "Successfully created country."
        expect(page).to have_content country.name
        logout(user)
      end

      it "Edits a Country and displays the results" do
        user = FactoryGirl.create(:admin_user)
        country = FactoryGirl.create(:country)
        country_template = FactoryGirl.build(:country)
        country_template.name = country_template.name + "new"
        login(user)
        visit countries_url
        within "#country_#{country.id}" do
          click_link 'Edit'
        end
        fill_in 'country_name', with: country_template.name
        click_button "Submit"
        expect(page).to have_content "Successfully updated country."
        expect(page).to have_content country_template.name
        country_new = Country.find(country.id)
        expect(country_new.name).to eq(country_template.name)
        expect(country_new.name).not_to eq(country.name)
        logout(user)
      end
    end

    it "Deletes a Feature type", js: true do
      user = FactoryGirl.create(:admin_user)
      login(user)
      visit countries_path
      expect{
        within "#country_#{@country.id}" do
          click_link 'Delete'
        end
        alert = page.driver.browser.switch_to.alert
        alert.accept
        expect(page).to have_css('div.alert-success')
      }.to change(Country,:count).by(-1)
      expect(page).to have_content "Successfully destroyed country."
      expect(current_path).to eq(countries_path)
      expect(page).not_to have_content @country.name
    end
  end
end
