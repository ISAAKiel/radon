require 'spec_helper'

#save_and_open_page

describe "CountrySubdivisions", type: :feature do

  before(:each, :js=>true) do
    @country_subdivision = FactoryGirl.create(:country_subdivision)
  end


  describe "GET /country_subdivisions" do
    it "displays the country_subdivisions" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      FactoryGirl.create(:country_subdivision, :name => 'test_country_subdivision2')
      FactoryGirl.create(:country_subdivision, :name => 'test_country_subdivision1')
      visit country_subdivisions_path
      expect(page).to have_content("test_country_subdivision1")
      expect(page).to have_content("test_country_subdivision2")
    end
  end

  describe "GET /country_subdivision" do
    it "displays the a country_subdivision" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      country_subdivision = FactoryGirl.create(:country_subdivision_with_sites)
      visit country_subdivisions_path
      find("#country_subdivision_#{country_subdivision.id}").click_link 'Show'
      expect(current_path).to eq(country_subdivision_path(country_subdivision))
      expect(page).to have_content(country_subdivision.name) 
    end
  end
  
  describe "Manage Country Subdivisions" do
    context "not logged in" do
      it "do not display the New link" do
        visit country_subdivisions_path
        expect(page).not_to have_link('New Country Subdivision', href: new_country_subdivision_path)
      end
      
      it "do not display the New form" do
        visit new_country_subdivision_path
        expect(current_path).not_to eq(new_country_subdivision_path)
      end

      it "do not display the Edit link" do
        @country_subdivision = FactoryGirl.create(:country_subdivision)
        visit country_subdivisions_path
        expect(page).not_to have_link('Edit', href: edit_country_subdivision_path(@country_subdivision))
      end

      it "do not display the Edit form" do
        @country_subdivision = FactoryGirl.create(:country_subdivision)
        visit edit_country_subdivision_path(@country_subdivision)
        expect(current_path).not_to eq(edit_country_subdivision_path(@country_subdivision))
      end

    end
    context "logged in admin_user" do
      it "do display the New link" do
        user = FactoryGirl.create(:admin_user)
        login(user)
        visit country_subdivisions_path
        expect(page).to have_link('New Country Subdivision', href: new_country_subdivision_path)
        logout(user)
      end

      it "Adds a new CountrySubdivision and displays the results" do
        user = FactoryGirl.create(:admin_user)
        country_subdivision = FactoryGirl.build(:country_subdivision)
        country_subdivision.name = country_subdivision.name + "new"
        login(user)
        visit country_subdivisions_url
        expect{
          click_link 'New Country Subdivision'
          fill_in 'Name', with: country_subdivision.name
          select(country_subdivision.country.name, :from => 'country_subdivision_country_id')
          click_button "Submit"
        }.to change(CountrySubdivision,:count).by(1)
        expect(page).to have_content "Successfully created country subdivision."
        expect(page).to have_content country_subdivision.name
        expect(page).to have_content country_subdivision.country.name
        logout(user)
      end

      it "Edits a CountrySubdivision and displays the results" do
        user = FactoryGirl.create(:admin_user)
        country_subdivision = FactoryGirl.create(:country_subdivision)
        country_subdivision_template = FactoryGirl.build(:country_subdivision)
        country_subdivision_template.name=country_subdivision_template.name + "new"
        login(user)
        visit country_subdivisions_url
        within "#country_subdivision_#{country_subdivision.id}" do
          click_link 'Edit'
        end
        fill_in 'Name', with: country_subdivision_template.name
        select(country_subdivision_template.country.name, :from => 'country_subdivision_country_id')
        click_button "Submit"
        expect(page).to have_content "Successfully updated country subdivision."
        expect(page).to have_content country_subdivision_template.name
        expect(page).to have_content country_subdivision_template.country.name
        country_subdivision_new = CountrySubdivision.find(country_subdivision.id)
        expect(country_subdivision_new.name).to eq(country_subdivision_template.name)
        expect(country_subdivision_new.country.name).to eq(country_subdivision_template.country.name)
        expect(country_subdivision_new.name).not_to eq(country_subdivision.name)
        expect(country_subdivision_new.country).not_to eq(country_subdivision.country.name)
        logout(user)
      end
    end

    it "Deletes a CountrySubdivision", js: true do
      user = FactoryGirl.create(:admin_user)
      login(user)
      visit country_subdivisions_path
      expect{
        within "#country_subdivision_#{@country_subdivision.id}" do
          click_link 'Delete'
        end
        alert = page.driver.browser.switch_to.alert
        alert.accept
        expect(page).to have_css('div.alert-success')
      }.to change(CountrySubdivision,:count).by(-1)
      expect(page).to have_content "Successfully destroyed country subdivision."
      expect(current_path).to eq(country_subdivisions_path)
      expect(page).not_to have_content @country_subdivision.name
    end
  end
end
