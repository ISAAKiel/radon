require 'spec_helper'

#save_and_open_page

describe "Prmats", type: :feature do

  before(:each) do
    FactoryGirl.create(:page,:name => 'home' )
    FactoryGirl.create(:announcement)
  end

  before(:each, :js=>true) do
    @prmat = FactoryGirl.create(:prmat)
  end


  describe "GET /prmats" do
    it "displays the prmats" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      FactoryGirl.create(:prmat, :name => 'test_prmat2')
      FactoryGirl.create(:prmat, :name => 'test_prmat1')
      visit prmats_path
      expect(page).to have_content("test_prmat1")
      expect(page).to have_content("test_prmat2")
    end
  end

  describe "GET /prmat" do
    it "displays the a prmat" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      prmat = FactoryGirl.create(:prmat)
      visit prmats_path
      find("#prmat_#{prmat.id}").click_link 'Show'
      expect(current_path).to eq(prmat_path(prmat))
      expect(page).to have_content(prmat.name) 
    end
  end
  
  describe "Manage Feature Types" do
    context "not logged in" do
      it "do not display the New link" do
        visit prmats_path
        expect(page).not_to have_link('New Prmat', href: new_prmat_path)
      end
      
      it "do not display the New form" do
        visit new_prmat_path
        expect(current_path).not_to eq(new_prmat_path)
      end

      it "do not display the Edit link" do
        @prmat = FactoryGirl.create(:prmat)
        visit prmats_path
        expect(page).not_to have_link('Edit', href: edit_prmat_path(@prmat))
      end

      it "do not display the Edit form" do
        @prmat = FactoryGirl.create(:prmat)
        visit edit_prmat_path(@prmat)
        expect(current_path).not_to eq(edit_prmat_path(@prmat))
      end

    end
    context "logged in admin_user" do
      it "do display the New link" do
        user = FactoryGirl.create(:admin_user)
        login(user)
        visit prmats_path
        expect(page).to have_link('New Sample material', href: new_prmat_path)
        logout(user)
      end

      it "Adds a new Prmat and displays the results" do
        user = FactoryGirl.create(:admin_user)
        prmat = FactoryGirl.build(:prmat)
        login(user)
        visit prmats_url
        expect{
          click_link 'New Sample material'
          fill_in 'Name', with: prmat.name
          click_button "Create Prmat"
        }.to change(Prmat,:count).by(1)
        expect(page).to have_content "Successfully created prmat."
        expect(page).to have_content prmat.name
        logout(user)
      end

      it "Edits a Prmat and displays the results" do
        user = FactoryGirl.create(:admin_user)
        prmat = FactoryGirl.create(:prmat)
        prmat_template = FactoryGirl.build(:prmat)
        login(user)
        visit prmats_url
        within "#prmat_#{prmat.id}" do
          click_link 'Edit'
        end
        fill_in 'Name', with: prmat_template.name
        click_button "Update Prmat"
        expect(page).to have_content "Successfully updated prmat."
        expect(page).to have_content prmat_template.name
        prmat_new = Prmat.find(prmat.id)
        expect(prmat_new.name).to eq(prmat_template.name)
        expect(prmat_new.name).not_to eq(prmat.name)
        logout(user)
      end
    end

    it "Deletes a Prmat", js: true do
      user = FactoryGirl.create(:admin_user)
      login(user)
      visit prmats_path
      expect{
        within "#prmat_#{@prmat.id}" do
          click_link 'Delete'
        end
        alert = page.driver.browser.switch_to.alert
        alert.accept
        expect(page).to have_css('div.alert-success')
      }.to change(Prmat,:count).by(-1)
      expect(page).to have_content "Successfully destroyed prmat."
      expect(current_path).to eq(prmats_path)
      expect(page).not_to have_content @prmat.name
    end
  end
end
