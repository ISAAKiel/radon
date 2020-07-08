require 'rails_helper'

#save_and_open_page

describe "Labs", type: :feature do

  before(:each) do
    FactoryBot.create(:page,:name => 'home' )
    FactoryBot.create(:announcement)
  end

  before(:each, :js=>true) do
    @lab = FactoryBot.create(:lab)
  end


  describe "GET /labs" do
    it "displays the labs" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      FactoryBot.create(:lab, :name => 'test_lab2')
      FactoryBot.create(:lab, :name => 'test_lab1')
      visit labs_path
      expect(page).to have_content("test_lab1")
      expect(page).to have_content("test_lab2")
    end
  end

  describe "GET /lab" do
    it "displays the a lab" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      lab = FactoryBot.create(:lab)
      visit labs_path
      find("#lab_#{lab.id}").click_link 'Show'
      expect(current_path).to eq(lab_path(lab))
      expect(page).to have_content(lab.name) 
    end
  end
  
  describe "Manage Feature Types" do
    context "not logged in" do
      it "do not display the New link" do
        visit labs_path
        expect(page).not_to have_link('New Laboratory', href: new_lab_path)
      end
      
      it "do not display the New form" do
        visit new_lab_path
        expect(current_path).not_to eq(new_lab_path)
      end

      it "do not display the Edit link" do
        @lab = FactoryBot.create(:lab)
        visit labs_path
        expect(page).not_to have_link('Edit', href: edit_lab_path(@lab))
      end

      it "do not display the Edit form" do
        @lab = FactoryBot.create(:lab)
        visit edit_lab_path(@lab)
        expect(current_path).not_to eq(edit_lab_path(@lab))
      end

    end
    context "logged in admin_user" do
      it "do display the New link" do
        user = FactoryBot.create(:admin_user)
        login(user)
        visit labs_path
        expect(page).to have_link('New Laboratory', href: new_lab_path)
        logout(user)
      end

      it "Adds a new Lab and displays the results" do
        user = FactoryBot.create(:admin_user)
        dating_method = FactoryBot.create(:dating_method)
        lab = FactoryBot.build(:lab, dating_method: dating_method)
        login(user)
        visit labs_url
        click_link 'New Laboratory'
        fill_in 'Name', with: lab.name
        fill_in 'Lab code', with: lab.lab_code
        select(dating_method.name, :from => 'lab_dating_method_id')
        check "lab_active" if lab.active
        expect{
          click_button "Create Lab"
        }.to change(Lab,:count).by(1)
        expect(page).to have_content "Successfully created lab."
        expect(page).to have_content lab.name
        expect(page).to have_content lab.lab_code
        expect(page).to have_content lab.dating_method.name
        expect(page).to have_content lab.active
        logout(user)
      end

      it "Edits a Lab and displays the results" do
        user = FactoryBot.create(:admin_user)
        lab = FactoryBot.create(:lab)
        dating_method = FactoryBot.create(:dating_method)
        lab_template = FactoryBot.build(:lab, :active => !lab.active, dating_method: dating_method)
        login(user)
        visit labs_url
        within "#lab_#{lab.id}" do
          click_link 'Edit'
        end
        fill_in 'Name', with: lab_template.name
        fill_in 'Lab code', with: lab_template.lab_code
        select(lab_template.dating_method.name, :from => 'lab_dating_method_id')
        if lab_template.active
          check "lab_active"
        else
          uncheck "lab_active"
        end
        click_button "Update Lab"
        expect(page).to have_content "Successfully updated lab."
        expect(page).to have_content lab_template.name
        expect(page).to have_content lab_template.lab_code
        expect(page).to have_content lab_template.dating_method.name
        expect(page).to have_content lab_template.active
        lab_new = Lab.find(lab.id)
        expect(lab_new.name).to eq(lab_template.name)
        expect(lab_new.lab_code).to eq(lab_template.lab_code)
        expect(lab_new.dating_method.name).to eq(lab_template.dating_method.name)
        expect(lab_new.active).to eq(lab_template.active)
        expect(lab_new.name).not_to eq(lab.name)
        expect(lab_new.lab_code).not_to eq(lab.lab_code)
        expect(lab_new.dating_method.name).not_to eq(lab.dating_method.name)
        expect(lab_new.active).not_to eq(lab.active)
        logout(user)
      end
    end

    it "Deletes a Lab", js: true do
      FactoryBot.create(:admin_user)
      user = FactoryBot.create(:admin_user)
      login(user)
      visit labs_path
      expect{
        within "#lab_#{@lab.id}" do
          page.accept_confirm { click_link "Delete" }
        end
        expect(page).to have_css('div.alert-success')
      }.to change(Lab,:count).by(-1)
      expect(page).to have_content "Successfully destroyed lab."
      expect(current_path).to eq(labs_path)
      expect(page).not_to have_content @lab.name
    end
  end
end
