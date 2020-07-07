require 'rails_helper'

#save_and_open_page

describe "Rights", type: :feature do

  before(:each) do
    FactoryBot.create(:right)
    @right = FactoryBot.create(:right)
  end


  describe "GET /rights" do
    context "not logged in" do
      it "do not displays the rights" do
        # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
        FactoryBot.create(:right, :name => 'test_right2')
        FactoryBot.create(:right, :name => 'test_right1')
        visit rights_path
        expect(current_path).not_to eq(rights_path)
        expect(page).not_to have_content("test_right1")
        expect(page).not_to have_content("test_right2")
      end
    end
    context "logged in as admin" do
      it "displays the rights" do
        # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
        FactoryBot.create(:right, :name => 'test_right2')
        FactoryBot.create(:right, :name => 'test_right1')
        user = FactoryBot.create(:admin_user)
        login(user)
        visit rights_path
        expect(current_path).to eq(rights_path)
        expect(page).to have_content("test_right1")
        expect(page).to have_content("test_right2")
        logout(user)
      end
    end
  end

  describe "GET /right" do
    context "logged in as admin user" do
      it "displays the a right" do
        # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
        right = FactoryBot.create(:right)
        user = FactoryBot.create(:admin_user)
        login(user)
        visit rights_path
#        save_and_open_page
        find("#right_#{right.id}").click_link 'Show'
        expect(current_path).to eq(right_path(right))
        expect(page).to have_content(right.name) 
        logout(user)
      end
    end
  end
  
  describe "Manage Feature Types" do
    context "not logged in" do
      it "do not display the New link" do
        visit rights_path
        expect(page).not_to have_link('New Right', href: new_right_path)
      end
      
      it "do not display the New form" do
        visit new_right_path
        expect(current_path).not_to eq(new_right_path)
      end

      it "do not display the Edit link" do
        @right = FactoryBot.create(:right)
        visit rights_path
        expect(page).not_to have_link('Edit', href: edit_right_path(@right))
      end

      it "do not display the Edit form" do
        @right = FactoryBot.create(:right)
        visit edit_right_path(@right)
        expect(current_path).not_to eq(edit_right_path(@right))
      end

    end
    context "logged in admin_user" do
      it "do display the New link" do
        user = FactoryBot.create(:admin_user)
        login(user)
        visit rights_path
        expect(page).to have_link('New Right', href: new_right_path)
        logout(user)
      end

      it "Adds a new Right and displays the results" do
        user = FactoryBot.create(:admin_user)
        right = FactoryBot.build(:right)
        login(user)
        visit rights_path
        expect{
          click_link 'New Right'
          fill_in 'Name', with: right.name
          click_button "Create Right"
        }.to change(Right,:count).by(1)
        expect(page).to have_content "Successfully created right."
        expect(page).to have_content right.name
        logout(user)
      end

      it "Edits a Right and displays the results" do
        user = FactoryBot.create(:admin_user)
        right = FactoryBot.create(:right)
        right_template = FactoryBot.build(:right)
        login(user)
        visit rights_url
        within "#right_#{right.id}" do
          click_link 'Edit'
        end
        fill_in 'Name', with: right_template.name
        click_button "Update Right"
        expect(page).to have_content "Successfully updated right."
        expect(page).to have_content right_template.name
        right_new = Right.find(right.id)
        expect(right_new.name).to eq(right_template.name)
        expect(right_new.name).not_to eq(right.name)
        logout(user)
      end
    end

    it "Deletes a Feature type", js: true do
      user = FactoryBot.create(:admin_user)
      login(user)
      visit rights_path
      expect{
        within "#right_#{@right.id}" do
          page.accept_confirm { click_link "Delete" }
        end
        expect(page).to have_css('div.alert-success')
      }.to change(Right,:count).by(-1)
      expect(page).to have_content "Successfully destroyed right."
      expect(current_path).to eq(rights_path)
      expect(page).not_to have_content @right.name
    end
  end
end
