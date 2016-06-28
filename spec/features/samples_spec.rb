require 'spec_helper'

#save_and_open_page

def fill_in_standard_sample(sample)
  select(sample.lab.lab_code, :from => 'sample_lab_id')
  fill_in 'Sample Number', with: sample.lab_nr
  fill_in 'Uncalibrated date', with: sample.bp
  fill_in 'Standard deviation', with: sample.std
  select(sample.prmat.name, :from => 'sample_prmat_id')
  select(sample.feature_type.name, :from => 'sample_feature_type_id')
  select(sample.phase.culture.name, :from => 'sample_culture_id')
  select(sample.phase.name, :from => 'sample_phase_id')
  select(sample.right.name, :from => 'sample_right_id')
  select(sample.tenants.first.name, :from => 'sample_tenant_ids')
end

def check_standard_sample(sample)
  expect(page).to have_content sample.lab.lab_code
  expect(page).to have_content sample.lab_nr
  expect(page).to have_content sample.bp
  expect(page).to have_content sample.std
  expect(page).to have_content sample.prmat.name
  expect(page).to have_content sample.feature_type.name
  expect(page).to have_content sample.phase.culture.name
  expect(page).to have_content sample.phase.name
  expect(page).to have_content sample.right.name
end

describe "Samples" do
include Rails.application.routes.url_helpers

  before(:all) do
#    FactoryGirl.create(:tenant, name: "Radon", subdomain: "radon")
    Capybara.app_host = 'http://radon.local:3000'
  end

  before(:each, :js=>true) do
    @sample = FactoryGirl.create(:sample_for_radon)
  end

  describe "GET /samples" do

    before(:each) do
      FactoryGirl.create(:right, id: 1)
      FactoryGirl.create(:sample_for_radon, :lab_nr => '12345', right_id: 1)
      FactoryGirl.create(:sample_for_radon, :lab_nr => '54321', right_id: 1)
      visit samples_path
    end

    it "displays the samples" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      expect(page).to have_content("12345")
      expect(page).to have_content("54321")
    end

    it "has the map functionalities", js: true do
      pending("dragdrop laeuft momentan nicht")
      click_link("Show/Hide Map")
      expect(page).to have_selector('#map')
      click_button("Draw Selection Frame")

      page.execute_script("$('#map').prepend($('<div id=\"test_drop_source\" style=\"position:absolute; top:300px; left:300px; z-index:-1000; width:10px; height:10px;\" ></div>'))")
      page.execute_script("$('#map').prepend($('<div id=\"test_drop_target\" style=\"position:absolute; top:500px; left:500px; z-index:-1000; width:10px; height:10px;\" ></div>'))")

      source = page.first('#test_drop_source')
      target = page.first('#test_drop_target')
      source.drag_to target
      click_button("Enable filter")
      expect(current_path).to eq(samples_path)
      expect(current_url.to_s).to include('bbox')
    end
  end

  describe "GET /sample" do
    it "displays the a sample" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      sample = FactoryGirl.create(:sample_for_radon)
      visit samples_path
      find("#sample_#{sample.id}").click_link 'Show'
      expect(current_path).to eq(sample_path(sample))
      expect(page).to have_content(sample.lab_nr) 
    end
  end
  
  describe "Manage Samples" do
    context "not logged in" do
      it "do not display the New link" do
        visit samples_path
        expect(page).not_to have_link('New', href: new_sample_path)
      end
      
      it "do not display the New form" do
        visit new_sample_path
        expect(current_path).not_to eq(new_sample_path)
      end

      it "do not display the Edit link" do
        @sample = FactoryGirl.create(:sample_for_radon)
        visit samples_path
        expect(page).not_to have_link('Edit', href: edit_sample_path(@sample))
      end

      it "do not display the Edit form" do
        @sample = FactoryGirl.create(:sample_for_radon)
        visit edit_sample_path(@sample)
        expect(current_path).not_to eq(edit_sample_path(@sample))
      end

    end
    context "logged in admin_user" do
      it "do display the New link" do
        user = FactoryGirl.create(:admin_user)
        login(user)
        visit samples_path
        expect(page).to have_link('New', href: new_sample_path)
        logout(user)
      end

      it "Adds a new Sample with new site lat lng and displays the results", js: true do
        user = FactoryGirl.create(:admin_user)
        sample = FactoryGirl.create(:sample_for_radon)
        site=FactoryGirl.build(:site)

        login(user)
        visit samples_path
        expect{
          click_link 'New'
          fill_in 'sample_site_attributes_lat', with: site.lat
          fill_in 'sample_site_attributes_lng', with: site.lng
          fill_in 'sample_site_attributes_name', with: site.name
          fill_in_standard_sample(sample)
          click_button "Submit"
        }.to change(Sample.unscoped,:count).by(1)

        expect(page).to have_content site.name
        logout(user)
      end

      it "Adds a new Sample with existing site and displays the results", js: true do
        user = FactoryGirl.create(:admin_user)
        sample = FactoryGirl.create(:sample_for_radon)
        site=FactoryGirl.create(:site)

        login(user)
        visit samples_path
        expect{
          click_link 'New'
          fill_in 'search', with: site.name
          click_button 'Search'
          within '#locations_from_site' do
            click_link 'Select'
          end
          fill_in_standard_sample(sample)
          click_button "Submit"
        }.to change(Sample.unscoped,:count).by(1)
        expect(page).to have_content "Successfully created sample."
        check_standard_sample(sample)
        expect(page).to have_content site.name
        logout(user)
      end

      it "creates a Sample with adding existing literature and displays the results", js: true do
        user = FactoryGirl.create(:admin_user)
        sample = FactoryGirl.create(:sample_for_radon)
        literature_template = FactoryGirl.create(:literature)
        site=FactoryGirl.create(:site)

        login(user)
        visit samples_path
        expect{
          click_link 'New'
          fill_in 'search', with: site.name
          click_button 'Search'
          within '#locations_from_site' do
            click_link 'Select'
          end
          fill_in_standard_sample(sample)
          click_link "Add Literature"
          click_link "or choose existing Literature"
          find('.existing_literature').find('input').set(literature_template.short_citation)
          expect(page).to have_selector(:css, '.ui-autocomplete')
          within('.ui-autocomplete') do
            find("a", :text => literature_template.short_citation).click
          end
          click_button "Submit"
        }.to change(Sample.unscoped,:count).by(1)
        expect(page).to have_content "Successfully created sample."
        check_standard_sample(sample)
        expect(page).to have_content literature_template.long_citation
        logout(user)
      end

      it "Edits a Sample and displays the results", js: true do
        user = FactoryGirl.create(:admin_user)
        sample = FactoryGirl.create(:sample_for_radon)
        sample_template = FactoryGirl.create(:sample_for_radon)
        login(user)
        visit samples_path
        within "#sample_#{sample.id}" do
          click_link 'Edit'
        end
        fill_in_standard_sample(sample_template)
        click_button "Submit"
        expect(page).to have_content "Successfully updated sample."
        check_standard_sample(sample_template)
        logout(user)
      end

      it "edits a Sample with adding existing literature and displays the results", js: true do
        user = FactoryGirl.create(:admin_user)
        sample = FactoryGirl.create(:sample_for_radon)
        sample_template = FactoryGirl.create(:sample_for_radon)
        literature_template = FactoryGirl.create(:literature)
        login(user)
        visit samples_path
        within "#sample_#{sample.id}" do
          click_link 'Edit'
        end
        fill_in_standard_sample(sample_template)
        click_link "Add Literature"
        click_link "or choose existing Literature"
        find('.existing_literature').find('input').set(literature_template.short_citation)
        expect(page).to have_selector(:css, '.ui-autocomplete')
        within('.ui-autocomplete') do
          find("a", :text => literature_template.short_citation).click
        end
        click_button "Submit"
        expect(page).to have_content "Successfully updated sample."
        check_standard_sample(sample_template)
        expect(page).to have_content literature_template.long_citation
        logout(user)
      end
    end

    it "Deletes a Sample", js: true do
      user = FactoryGirl.create(:admin_user)
      login(user)
      visit samples_path
      expect{
        within "#sample_#{@sample.id}" do
          click_link 'Delete'
        end
        alert = page.driver.browser.switch_to.alert
        alert.accept
        expect(page).to have_css('div.alert-success')
      }.to change(Sample,:count).by(-1)
      expect(page).to have_content "Successfully destroyed sample."
      expect(current_path).to eq(samples_path)
      expect(page).not_to have_content @sample.name
    end
  end
end
