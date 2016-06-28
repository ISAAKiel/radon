require 'spec_helper'

describe "announcements/index", :type => :view do

  before(:each) do
    assign(:announcements, [
      stub_model(Announcement,
        :title => "Title",
        :content => "MyText"
      ),
      stub_model(Announcement,
        :title => "Title",
        :content => "MyText"
      )
    ])
  end

  it "renders a list of announcements" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "h2", :text => "Title".to_s, :count => 2
    assert_select "p", :text => "MyText".to_s, :count => 2
  end
end
