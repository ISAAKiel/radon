require 'spec_helper'

#save_and_open_page

describe "FeatureTypes", type: :feature do

  before(:each, :js=>true) do
    @feature_type = FactoryGirl.create(:feature_type)
  end


  describe "GET /feature_types" do
    it "displays the feature_types" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      FactoryGirl.create(:feature_type, :name => 'test_feature_type2')
      FactoryGirl.create(:feature_type, :name => 'test_feature_type1')
      visit feature_types_path
      expect(page).to have_content("test_feature_type1")
      expect(page).to have_content("test_feature_type2")
    end
  end

  describe "GET /feature_type" do
    it "displays the a feature_type" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      feature_type = FactoryGirl.create(:feature_type)
      visit feature_types_path
      find("#feature_type_#{feature_type.id}").click_link 'Show'
      expect(current_path).to eq(feature_type_path(feature_type))
      expect(page).to have_content(feature_type.name) 
    end
  end
  
  describe "Manage Feature Types" do
    context "not logged in" do
      it "do not display the New link" do
        visit feature_types_path
        expect(page).not_to have_link('New Feature Type', href: new_feature_type_path)
      end
      
      it "do not display the New form" do
        visit new_feature_type_path
        expect(current_path).not_to eq(new_feature_type_path)
      end

      it "do not display the Edit link" do
        @feature_type = FactoryGirl.create(:feature_type)
        visit feature_types_path
        expect(page).not_to have_link('Edit', href: edit_feature_type_path(@feature_type))
      end

      it "do not display the Edit form" do
        @feature_type = FactoryGirl.create(:feature_type)
        visit edit_feature_type_path(@feature_type)
        expect(current_path).not_to eq(edit_feature_type_path(@feature_type))
      end

    end
    context "logged in admin_user" do
      it "do display the New link" do
        user = FactoryGirl.create(:admin_user)
        login(user)
        visit feature_types_path
        expect(page).to have_link('New Feature Type', href: new_feature_type_path)
        logout(user)
      end

      it "Adds a new FeatureType and displays the results" do
        user = FactoryGirl.create(:admin_user)
        feature_type = FactoryGirl.build(:feature_type)
        login(user)
        visit feature_types_url
        expect{
          click_link 'New Feature Type'
          fill_in 'Name', with: feature_type.name
          fill_in 'Comment', with: feature_type.comment
          click_button "Create Feature type"
        }.to change(FeatureType,:count).by(1)
        expect(page).to have_content "Successfully created feature type."
        expect(page).to have_content feature_type.name
        expect(page).to have_content feature_type.comment
        logout(user)
      end

      it "Edits a FeatureType and displays the results" do
        user = FactoryGirl.create(:admin_user)
        feature_type = FactoryGirl.create(:feature_type)
        feature_type_template = FactoryGirl.build(:feature_type)
        login(user)
        visit feature_types_url
        within "#feature_type_#{feature_type.id}" do
          click_link 'Edit'
        end
        fill_in 'Name', with: feature_type_template.name
        fill_in 'Comment', with: feature_type_template.comment
        click_button "Update Feature type"
        expect(page).to have_content "Successfully updated feature type."
        expect(page).to have_content feature_type_template.name
        expect(page).to have_content feature_type_template.comment
        feature_type_new = FeatureType.find(feature_type.id)
        expect(feature_type_new.name).to eq(feature_type_template.name)
        expect(feature_type_new.comment).to eq(feature_type_template.comment)
        expect(feature_type_new.name).not_to eq(feature_type.name)
        expect(feature_type_new.comment).not_to eq(feature_type.comment)
        logout(user)
      end
    end

    it "Deletes a Feature type", js: true do
      user = FactoryGirl.create(:admin_user)
      login(user)
      visit feature_types_path
      expect{
        within "#feature_type_#{@feature_type.id}" do
          click_link 'Delete'
        end
        alert = page.driver.browser.switch_to.alert
        alert.accept
        expect(page).to have_css('div.alert-success')
      }.to change(FeatureType,:count).by(-1)
      expect(page).to have_content "Successfully destroyed feature type."
      expect(current_path).to eq(feature_types_path)
      expect(page).not_to have_content @feature_type.name
    end
  end
end
