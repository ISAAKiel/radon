require "spec_helper"

describe AnnouncementsController, type: :controller do
  describe "routing" do

    it "routes to #index" do
      expect({ :get => "/announcements" }).
      to route_to(:controller => "announcements", :action => "index")
#      get("/announcements").should route_to("announcements#index")
    end

    it "routes to #new" do
      expect({ :get => "/announcements/new" }).
      to route_to(:controller => "announcements", :action => "new")
    end

    it "routes to #show" do
      expect({ :get => "/announcements/1" }).
      to route_to(:controller => "announcements", :action => "show", :id => "1")
    end

    it "routes to #edit" do
      expect({ :get => "/announcements/1/edit" }).
      to route_to(:controller => "announcements", :action => "edit", :id => "1")
    end

    it "routes to #create" do
      expect({ :post => "/announcements" }).
      to route_to(:controller => "announcements", :action => "create")
    end

    it "routes to #update" do
      expect({ :put => "/announcements/1" }).
      to route_to(:controller => "announcements", :action => "update", :id => "1")
    end

    it "routes to #destroy" do
      expect({ :delete => "/announcements/1" }).
      to route_to(:controller => "announcements", :action => "destroy", :id => "1")
    end

  end
end
