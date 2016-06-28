require "spec_helper"

describe PrmatsController, type: :controller do
  describe "routing" do

    it "routes to #index" do
      expect({ :get => "/prmats" }).
      to route_to(:controller => "prmats", :action => "index")
#      get("/prmats").should route_to("prmats#index")
    end

    it "routes to #new" do
      expect({ :get => "/prmats/new" }).
      to route_to(:controller => "prmats", :action => "new")
    end

    it "routes to #show" do
      expect({ :get => "/prmats/1" }).
      to route_to(:controller => "prmats", :action => "show", :id => "1")
    end

    it "routes to #edit" do
      expect({ :get => "/prmats/1/edit" }).
      to route_to(:controller => "prmats", :action => "edit", :id => "1")
    end

    it "routes to #create" do
      expect({ :post => "/prmats" }).
      to route_to(:controller => "prmats", :action => "create")
    end

    it "routes to #update" do
      expect({ :put => "/prmats/1" }).
      to route_to(:controller => "prmats", :action => "update", :id => "1")
    end

    it "routes to #destroy" do
      expect({ :delete => "/prmats/1" }).
      to route_to(:controller => "prmats", :action => "destroy", :id => "1")
    end

  end
end
