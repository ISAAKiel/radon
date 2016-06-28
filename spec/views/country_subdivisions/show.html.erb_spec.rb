require 'spec_helper'

describe "country_subdivisions/show", :type => :view do
  before(:each) do
    @country_subdivision = assign(:country_subdivision, FactoryGirl.build(:country_subdivision))
  end

  it "renders attributes in <p>" do
    allow(controller).to receive(:current_user).and_return(FactoryGirl.build(:user))
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end

  it "displays sites" do
    assign(:country_subdivision_with_sites, FactoryGirl.build(:country_subdivision_with_sites))
    allow(controller).to receive(:current_user).and_return(FactoryGirl.build(:user))
    render
    
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
