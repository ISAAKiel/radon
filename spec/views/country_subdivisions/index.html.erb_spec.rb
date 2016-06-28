require 'spec_helper'
require 'wice_grid'

describe "prmats/index", :type => :view do
  include Wice::Controller # this will add the initialize_grid method

  before(:each) do
    assign(:prmats_grid, initialize_grid(Prmat,
    :name => 'prmats',
    :enable_export_to_csv => false,
    :csv_file_name => 'prmats'
    ))
    FactoryGirl.create(:prmat, name: 'Material1')
    FactoryGirl.create(:prmat, name: 'Material2')
  end

#  before(:each, :admin_user_logged_in => true) do
#    @admin_user = FactoryGirl.create(:admin_user)
#    activate_authlogic
#    UserSession.create(@admin_user)
#  end

  context "as admin user", :admin_user_logged_in => true do
    it "renders a list of prmats" do
      allow(controller).to receive(:current_user).and_return(@admin_user)
      render
      expect(rendered).to include("Material1")
      expect(rendered).to include("Material2")
      # Run the generator again with the --webrat flag if you want to use webrat matchers
    end
    it "is admin_specific"
  end

  context "as guest" do
    it "renders a list of prmats" do
      allow(controller).to receive(:current_user).and_return(FactoryGirl.build(:user))
      render
      expect(rendered).to include("Material1")
      expect(rendered).to include("Material2")
      # Run the generator again with the --webrat flag if you want to use webrat matchers
    end
  end
end
