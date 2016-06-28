require 'spec_helper'

#save_and_open_page

describe "DatingMethods", type: :feature do

  before(:each) do
    FactoryGirl.create(:dating_method)
    @dating_method = FactoryGirl.create(:dating_method)
  end


  describe "GET /dating_methods" do
    context "not logged in" do
      it "displays the dating_methods" do
        # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
        FactoryGirl.create(:dating_method, :name => 'test_dating_method2')
        FactoryGirl.create(:dating_method, :name => 'test_dating_method1')
        visit dating_methods_path
        expect(current_path).not_to eq(dating_methods_path)
        expect(page).not_to have_content("test_dating_method1")
        expect(page).not_to have_content("test_dating_method2")
      end
    end
    context "logged in as admin" do
      it "displays the dating_methods" do
        # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
        FactoryGirl.create(:dating_method, :name => 'test_dating_method2')
        FactoryGirl.create(:dating_method, :name => 'test_dating_method1')
        user = FactoryGirl.create(:admin_user)
        login(user)
        visit dating_methods_path
        expect(current_path).to eq(dating_methods_path)
        expect(page).to have_content("test_dating_method1")
        expect(page).to have_content("test_dating_method2")
        logout(user)
      end
    end
  end

  describe "GET /dating_method" do
    context "logged in as admin user" do
      it "displays the a dating_method" do
        # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
        dating_method = FactoryGirl.create(:dating_method)
        user = FactoryGirl.create(:admin_user)
        login(user)
        visit dating_methods_path
#        save_and_open_page
        find("#dating_method_#{dating_method.id}").click_link 'Show'
        expect(current_path).to eq(dating_method_path(dating_method))
        expect(page).to have_content(dating_method.name) 
        logout(user)
      end
    end
  end
  
  describe "Manage DatingMethods" do
    context "not logged in" do
      it "do not display the New link" do
        visit dating_methods_path
        expect(page).not_to have_link('New Dating Method', href: new_dating_method_path)
      end
      
      it "do not display the New form" do
        visit new_dating_method_path
        expect(current_path).not_to eq(new_dating_method_path)
      end

      it "do not display the Edit link" do
        @dating_method = FactoryGirl.create(:dating_method)
        visit dating_methods_path
        expect(page).not_to have_link('Edit', href: edit_dating_method_path(@dating_method))
      end

      it "do not display the Edit form" do
        @dating_method = FactoryGirl.create(:dating_method)
        visit edit_dating_method_path(@dating_method)
        expect(current_path).not_to eq(edit_dating_method_path(@dating_method))
      end

    end
    context "logged in admin_user" do
      it "do display the New link" do
        user = FactoryGirl.create(:admin_user)
        login(user)
        visit dating_methods_path
        expect(page).to have_link('New Dating Method', href: new_dating_method_path)
        logout(user)
      end

      it "Adds a new DatingMethod and displays the results" do
        user = FactoryGirl.create(:admin_user)
        dating_method = FactoryGirl.build(:dating_method)
        login(user)
        visit dating_methods_path
        expect{
          click_link 'New Dating Method'
          fill_in 'Name', with: dating_method.name
          click_button "Create Dating method"
        }.to change(DatingMethod,:count).by(1)
        expect(page).to have_content "Successfully created dating method."
        expect(page).to have_content dating_method.name
        logout(user)
      end

      it "Edits a DatingMethod and displays the results" do
        user = FactoryGirl.create(:admin_user)
        dating_method = FactoryGirl.create(:dating_method)
        dating_method_template = FactoryGirl.build(:dating_method)
        login(user)
        visit dating_methods_url
        within "#dating_method_#{dating_method.id}" do
          click_link 'Edit'
        end
        fill_in 'Name', with: dating_method_template.name
        click_button "Update Dating method"
        expect(page).to have_content "Successfully updated dating method."
        expect(page).to have_content dating_method_template.name
        dating_method_new = DatingMethod.find(dating_method.id)
        expect(dating_method_new.name).to eq(dating_method_template.name)
        expect(dating_method_new.name).not_to eq(dating_method.name)
        logout(user)
      end
    end

    it "Deletes a Dating method", js: true do
      user = FactoryGirl.create(:admin_user)
      login(user)
      visit dating_methods_path
      expect{
        within "#dating_method_#{@dating_method.id}" do
          click_link 'Delete'
        end
        alert = page.driver.browser.switch_to.alert
        alert.accept
        expect(page).to have_css('div.alert-success')
      }.to change(DatingMethod,:count).by(-1)
      expect(page).to have_content "Successfully destroyed dating method."
      expect(current_path).to eq(dating_methods_path)
      expect(page).not_to have_content @dating_method.name
    end
  end
end
