require 'spec_helper'

describe "prmats/edit", :type => :view do
  before(:each) do
    @prmat = assign(:prmat, stub_model(Prmat))
  end

  it "renders the edit prmat form" do
    allow(controller).to receive(:current_user).and_return(FactoryGirl.build(:user))
    render
    assert_select "form[action=?][method=?]", prmat_path(@prmat), "post" do
      assert_select("label[for='prmat_name']")
      assert_select("input[type='text'][name='prmat[name]'][id='prmat_name']")
    end
  end
end
