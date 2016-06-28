require 'spec_helper'

describe "announcements/show", :type => :view do
  before(:each) do
    @announcement = assign(:announcement, stub_model(Announcement,
      :title => "Title",
      :content => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
  end
end
