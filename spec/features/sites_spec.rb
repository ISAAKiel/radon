require 'spec_helper'

#save_and_open_page

describe "Sites" do
include Rails.application.routes.url_helpers

  before(:each, :js=>true) do
    @site = FactoryGirl.create(:site)
  end

  describe "GET /sites" do
    it "displays the sites" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      FactoryGirl.create(:site, :name => 'test_site2')
      FactoryGirl.create(:site, :name => 'test_site1')
      visit sites_path
      expect(page).to have_content("test_site1")
      expect(page).to have_content("test_site2")
    end
  end

  describe "GET /site" do
    it "displays the a site" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      site = FactoryGirl.create(:site)
      visit sites_path
      find("#site_#{site.id}").click_link 'Show'
      expect(current_path).to eq(site_path(site))
      expect(page).to have_content(site.name) 
    end
  end
  
  describe "Manage Feature Types" do
    context "not logged in" do
      it "do not display the New link" do
        visit sites_path
        expect(page).not_to have_link('New Site', href: new_site_path)
      end
      
      it "do not display the New form" do
        visit new_site_path
        expect(current_path).not_to eq(new_site_path)
      end

      it "do not display the Edit link" do
        @site = FactoryGirl.create(:site)
        visit sites_path
        expect(page).not_to have_link('Edit', href: edit_site_path(@site))
      end

      it "do not display the Edit form" do
        @site = FactoryGirl.create(:site)
        visit edit_site_path(@site)
        expect(current_path).not_to eq(edit_site_path(@site))
      end

    end
    context "logged in admin_user" do
      it "do display the New link" do
        user = FactoryGirl.create(:admin_user)
        login(user)
        visit sites_path
        expect(page).to have_link('New Site', href: new_site_path)
        logout(user)
      end

      it "Adds a new Site via LatLong Enter and displays the results", js: true do
        user = FactoryGirl.create(:admin_user)
        site = FactoryGirl.build(:site)
        login(user)
        visit sites_path
        expect{
          click_link 'New Site'
        fill_in 'Name', with: site.name
        fill_in 'Lat', with: site.lat
        fill_in 'Lng', with: site.lng
        select(site.country_subdivision.country.name, :from => 'site_country_id')
        select(site.country_subdivision.name, :from => 'site_country_subdivision_id')
        fill_in 'Parish', with: site.parish
        fill_in 'District', with: site.district
          click_button "Create Site"
        }.to change(Site,:count).by(1)
        expect(page).to have_content "Successfully created site."
        expect(page).to have_content site.name
        expect(page).to have_content site.lat
        expect(page).to have_content site.lng
        expect(page).to have_content site.country_subdivision.country.name
        expect(page).to have_content site.country_subdivision.name
        expect(page).to have_content site.district
        expect(page).to have_content site.parish
        logout(user)
      end

      it "Edits a Site via LatLong Enter and displays the results", js: true do
        user = FactoryGirl.create(:admin_user)
        site = FactoryGirl.create(:site)
        country = FactoryGirl.create(:country_with_country_subdivisions)
        site_template = FactoryGirl.build(:site, :country_subdivision => country.country_subdivisions[0])
        login(user)
        visit sites_path
        within "#site_#{site.id}" do
          click_link 'Edit'
        end
        fill_in 'Name', with: site_template.name
        fill_in 'Lat', with: site_template.lat
        fill_in 'Lng', with: site_template.lng
        select(site_template.country_subdivision.country.name, :from => 'site_country_id')
        select(site_template.country_subdivision.name, :from => 'site_country_subdivision_id')
        fill_in 'Parish', with: site_template.parish
        fill_in 'District', with: site_template.district
        click_button "Update Site"
        expect(page).to have_content "Successfully updated site."
        expect(page).to have_content site_template.name
        expect(page).to have_content site_template.lat
        expect(page).to have_content site_template.lng
        expect(page).to have_content site_template.country_subdivision.country.name
        expect(page).to have_content site_template.country_subdivision.name
        expect(page).to have_content site_template.district
        expect(page).to have_content site_template.parish
        logout(user)
      end
    end

    it "Deletes a Site", js: true do
      user = FactoryGirl.create(:admin_user)
      login(user)
      visit sites_path
      expect{
        within "#site_#{@site.id}" do
          click_link 'Delete'
        end
        alert = page.driver.browser.switch_to.alert
        alert.accept
        expect(page).to have_css('div.alert-success')
      }.to change(Site,:count).by(-1)
      expect(page).to have_content "Successfully destroyed site."
      expect(current_path).to eq(sites_path)
      expect(page).not_to have_content @site.name
    end
  end
end
