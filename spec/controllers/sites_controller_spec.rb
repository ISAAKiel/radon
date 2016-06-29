require 'rails_helper'

describe SitesController, type: :controller do

  before(:all) do
    @valid_attribute_names = PermittedParams.new.site_attributes.map(&:to_s)
  end

  before(:each, :admin_user_logged_in => true) do
    @admin_user = FactoryGirl.create(:admin_user)
    activate_authlogic
    UserSession.create(@admin_user)
  end

  describe "GET index" do
    it "assigns all sites as @sites" do
      sites = FactoryGirl.create_list(:site,10)
      get :index, {}
      expect(assigns(:sites)).to match_array(sites)
    end
  end

  describe "GET show" do
    it "assigns the requested site as @site" do
      site = FactoryGirl.create(:site)
      get :show, {:id => site.to_param}
      expect(assigns(:site)).to eq(site)
    end
  end

  describe "GET new" do

    it "not assigns a new site as @site without admin user" do
      get :new
      expect(assigns(:site)).to be_nil
    end

    it "assigns a new site as @site with admin user", :admin_user_logged_in => true do
      get :new
      expect(assigns(:site)).to be_a_new(Site)
    end
  end

  describe "GET edit" do
    it "assigns the requested site as @site with admin user", :admin_user_logged_in => true do
      site = FactoryGirl.create(:site)
      get :edit, {:id => site.to_param}
      expect(assigns(:site)).to eq(site)
    end
    it "assigns the requested site as @site" do
      site = FactoryGirl.create(:site)
      get :edit, {:id => site.to_param}
      expect(assigns(:site)).to be_nil
    end
  end

  describe "POST create without admin_user" do
    describe "with valid params" do
      it "not creates a new Site" do
        attributes = FactoryGirl.attributes_for(:site)
        expect {
        post :create, {:site => attributes}
        }.not_to change(Site, :count)
      end

      it "redirects to the created site" do
        attributes = FactoryGirl.attributes_for(:site)
        post :create, {:site => attributes}
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "POST create with admin_user", :admin_user_logged_in => true do
    describe "with valid params" do
      it "creates a new Site" do
        attributes = FactoryGirl.attributes_for(:site)
        expect {
          post :create, {:site => attributes}
        }.to change(Site, :count).by(1)
      end

      it "assigns a newly created site as @site" do
        attributes = FactoryGirl.attributes_for(:site)
        post :create, {:site => attributes}
        expect(assigns(:site)).to be_a(Site)
        expect(assigns(:site)).to be_persisted
      end

      it "redirects to the created site" do
        attributes = FactoryGirl.attributes_for(:site)
        post :create, {:site => attributes}
        expect(response).to redirect_to(Site.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved site as @site" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Site).to receive(:save).and_return(false)
        post :create, {:site => { "these" => "params" }}
        expect(assigns(:site)).to be_a_new(Site)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Site).to receive(:save).and_return(false)
        post :create, {:site => { "these" => "params" }}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update without admin_user" do
    describe "with valid params" do
      it "updates the requested site" do
        site = FactoryGirl.create(:site)
        # Assuming there are no other sites in the database, this
        # specifies that the Site created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        expect_any_instance_of(Site).not_to receive(:update_attributes).with({ "these" => "params" })
      end

      it "assigns the requested site as @site" do
        site = FactoryGirl.create(:site)
        put :update, {:id => site.to_param, :site => site.attributes.slice(*@valid_attribute_names)}
        expect(assigns(:site)).to be_nil
      end

      it "redirects to root" do
        site = FactoryGirl.create(:site)
        put :update, {:id => site.to_param, :site => site.attributes.slice(*@valid_attribute_names)}
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "PUT update with admin_user", :admin_user_logged_in => true do
    describe "with valid params" do
      it "assigns the requested site as @site" do
        site = FactoryGirl.create(:site)
        site_attributes = FactoryGirl.attributes_for(:site)
        put :update, {:id => site.to_param, :site => site_attributes}
        expect(assigns(:site)).to eq(site)
      end

      it "redirects to the site" do
        site = FactoryGirl.create(:site)
        site_attributes = FactoryGirl.attributes_for(:site)
        put :update, {:id => site.to_param, :site => site_attributes}
        expect(response).to redirect_to(site)
      end
    end

    describe "with invalid params" do
      it "assigns the site as @site" do
        site = FactoryGirl.create(:site)
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Site).to receive(:save).and_return(false)
        put :update, {:id => site.to_param, :site => { "these" => "params" }}
        expect(assigns(:site)).to eq(site)
      end

      it "re-renders the 'edit' template" do
        site = FactoryGirl.create(:site)
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Site).to receive(:save).and_return(false)
        put :update, {:id => site.to_param, :site => { "these" => "params" }}
        expect(response).to render_template("edit") 
      end
    end
  end

  describe "DELETE destroy without admin_user" do
    it "not destroys the requested site" do
      site = FactoryGirl.create(:site)
      expect {
        delete :destroy, {:id => site.to_param}
      }.not_to change(Site, :count)
    end

    it "redirects to root" do
      site = FactoryGirl.create(:site)
      delete :destroy, {:id => site.to_param}
      expect(response).to redirect_to(root_url)
    end
  end

  describe "DELETE destroy with admin_user", :admin_user_logged_in => true do
    it "destroys the requested site" do
      site = FactoryGirl.create(:site)
      expect {
        delete :destroy, {:id => site.to_param}
      }.to change(Site, :count).by(-1)
    end

    it "redirects to the sites list" do
      site = FactoryGirl.create(:site)
      delete :destroy, {:id => site.to_param}
      expect(response).to redirect_to(sites_url)
    end
  end

end
