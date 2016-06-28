require 'spec_helper'

describe "prmats/new", :type => :view do
  before(:each) do
    assign(:prmat, stub_model(Prmat).as_new_record)
  end

  it "renders new prmat form" do
    render
    assert_select "form[action=?][method=?]", prmats_path, "post" do
      assert_select("label[for='prmat_name']")
      assert_select("input[type='text'][name='prmat[name]'][id='prmat_name']")
    end
  end
end
