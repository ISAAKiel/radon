require 'rails_helper'

describe AnnouncementsController, type: :controller do

  before(:all) do
    @valid_attribute_names = PermittedParams.new.announcement_attributes.map(&:to_s)
  end

  before(:each, :admin_user_logged_in => true) do
    @admin_user = FactoryGirl.create(:admin_user)
    activate_authlogic
    UserSession.create(@admin_user)
  end

  describe "GET index" do
    it "assigns all announcements as @announcements" do
      Announcement.delete_all
      announcements = FactoryGirl.create_list(:announcement,10)
      get :index, {}
      expect(assigns(:announcements)).to match_array(announcements)
    end
  end

  describe "GET show" do
    it "assigns the requested announcement as @announcement" do
      announcement = FactoryGirl.create(:announcement)
      get :show, {:id => announcement.to_param}
      expect(assigns(:announcement)).to eq(announcement)
    end
  end

  describe "GET new" do

    it "not assigns a new announcement as @announcement without admin user" do
      get :new
      expect(assigns(:announcement)).to be_nil
    end

    it "assigns a new announcement as @announcement with admin user", :admin_user_logged_in => true do
      get :new
      expect(assigns(:announcement)).to be_a_new(Announcement)
    end
  end

  describe "GET edit" do
    it "assigns the requested announcement as @announcement with admin user", :admin_user_logged_in => true do
      announcement = FactoryGirl.create(:announcement)
      get :edit, {:id => announcement.to_param}
      expect(assigns(:announcement)).to eq(announcement)
    end
    it "assigns the requested announcement as @announcement" do
      announcement = FactoryGirl.create(:announcement)
      get :edit, {:id => announcement.to_param}
      expect(assigns(:announcement)).to be_nil
    end
  end

  describe "POST create without admin_user" do
    describe "with valid params" do
      it "not creates a new Announcement" do
        attributes = FactoryGirl.attributes_for(:announcement)
        expect {
        post :create, {:announcement => attributes}
        }.not_to change(Announcement.unscoped, :count)
      end

      it "redirects to the created announcement" do
        attributes = FactoryGirl.attributes_for(:announcement)
        post :create, {:announcement => attributes}
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "POST create with admin_user", :admin_user_logged_in => true do
    describe "with valid params" do
      it "creates a new Announcement" do
        attributes = FactoryGirl.attributes_for(:announcement)
        expect {
          post :create, {:announcement => attributes}
        }.to change(Announcement.unscoped, :count).by(1)
      end

      it "assigns a newly created announcement as @announcement" do
        attributes = FactoryGirl.attributes_for(:announcement)
        post :create, {:announcement => attributes}
        expect(assigns(:announcement)).to be_a(Announcement)
        expect(assigns(:announcement)).to be_persisted
      end

      it "redirects to the created announcement" do
        attributes = FactoryGirl.attributes_for(:announcement)
        post :create, {:announcement => attributes}
        expect(response).to redirect_to(Announcement.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved announcement as @announcement" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Announcement).to receive(:save).and_return(false)
        post :create, {:announcement => { "these" => "params" }}
        expect(assigns(:announcement)).to be_a_new(Announcement)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Announcement).to receive(:save).and_return(false)
        post :create, {:announcement => { "these" => "params"   }}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update without admin_user" do
    describe "with valid params" do
      it "updates the requested announcement" do
        announcement = FactoryGirl.create(:announcement)
        # Assuming there are no other announcements in the database, this
        # specifies that the Announcement created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        expect_any_instance_of(Announcement).not_to receive(:update_attributes).with({ "these" => "params" })
      end

      it "assigns the requested announcement as @announcement" do
        announcement = FactoryGirl.create(:announcement)
        put :update, :id => announcement.to_param, :announcement => announcement.attributes.slice(*@valid_attribute_names)
        expect(assigns(:announcement)).to be_nil
      end

      it "redirects to the announcement" do
        announcement = FactoryGirl.create(:announcement)
        put :update, :id => announcement.to_param, :announcement => announcement.attributes.slice(*@valid_attribute_names)
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "PUT update with admin_user", :admin_user_logged_in => true do
    describe "with valid params" do
      it "assigns the requested announcement as @announcement" do
        announcement = FactoryGirl.create(:announcement)
        put :update, {:id => announcement.to_param, :announcement => announcement.attributes.slice(*@valid_attribute_names)}
        expect(assigns(:announcement)).to eq(announcement)
      end

      it "redirects to the announcement" do
        announcement = FactoryGirl.create(:announcement)
        put :update, {:id => announcement.to_param, :announcement => announcement.attributes.slice(*@valid_attribute_names)}
        expect(response).to redirect_to(announcement)
      end
    end

    describe "with invalid params" do
      it "assigns the announcement as @announcement" do
        announcement = FactoryGirl.create(:announcement)
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Announcement).to receive(:save).and_return(false)
        put :update, {:id => announcement.to_param, :announcement => {  "these" => "params"  }}
        expect(assigns(:announcement)).to eq(announcement)
      end

      it "re-renders the 'edit' template" do
        announcement = FactoryGirl.create(:announcement)
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Announcement).to receive(:save).and_return(false)
        put :update, {:id => announcement.to_param, :announcement => {  "these" => "params"  }}
        expect(response).to render_template("edit") 
      end
    end
  end

  describe "DELETE destroy without admin_user" do
    it "not destroys the requested announcement" do
      announcement = FactoryGirl.create(:announcement)
      expect {
        delete :destroy, {:id => announcement.to_param}
      }.not_to change(Announcement.unscoped, :count)
    end

    it "redirects to root" do
      announcement = FactoryGirl.create(:announcement)
      delete :destroy, {:id => announcement.to_param}
      expect(response).to redirect_to(root_url)
    end
  end

  describe "DELETE destroy with admin_user", :admin_user_logged_in => true do
    it "destroys the requested announcement" do
      announcement = FactoryGirl.create(:announcement)
      expect {
        delete :destroy, {:id => announcement.id}
      }.to change(Announcement.unscoped,:count).by(-1)
    end

    it "redirects to the announcements list" do
      announcement = FactoryGirl.create(:announcement)
      delete :destroy, {:id => announcement.to_param}
      expect(response).to redirect_to(announcements_url)
    end
  end

end
