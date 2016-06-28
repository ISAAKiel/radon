require 'spec_helper'

describe "prmats/show", :type => :view do
  before(:each) do
    @prmat = assign(:prmat, FactoryGirl.build(:prmat))
  end

  it "renders attributes in <p>" do
    allow(controller).to receive(:current_user).and_return(FactoryGirl.build(:user))
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
