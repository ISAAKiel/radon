require 'rails_helper'

describe "Announcements", type: :request do
  describe "GET /announcements" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get announcements_path
      expect(response.status).to be(200)
    end
  end
end
