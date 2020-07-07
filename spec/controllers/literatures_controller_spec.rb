require 'rails_helper'

describe LiteraturesController, type: :controller do

  before(:all) do
    @valid_attribute_names = PermittedParams.new.literature_attributes.map(&:to_s)
  end

  before(:each, :admin_user_logged_in => true) do
    @admin_user = FactoryBot.create(:admin_user)
    activate_authlogic
    UserSession.create(@admin_user)
  end

  describe "GET index" do
    it "assigns all literatures as @literatures" do
      literatures = FactoryBot.create_list(:literature,10)
      get :index, {}
      expect(assigns(:literatures)).to match_array(literatures)
    end
  end

  describe "GET show" do
    it "assigns the requested literature as @literature" do
      literature = FactoryBot.create(:literature)
      get :show, {:id => literature.to_param}
      expect(assigns(:literature)).to eq(literature)
    end
  end

  describe "GET new" do

    it "not assigns a new literature as @literature without admin user" do
      get :new
      expect(assigns(:literature)).to be_nil
    end

    it "assigns a new literature as @literature with admin user", :admin_user_logged_in => true do
      get :new
      expect(assigns(:literature)).to be_a_new(Literature)
    end
  end

  describe "GET edit" do
    it "assigns the requested literature as @literature with admin user", :admin_user_logged_in => true do
      literature = FactoryBot.create(:literature)
      get :edit, {:id => literature.to_param}
      expect(assigns(:literature)).to eq(literature)
    end
    it "assigns the requested literature as @literature" do
      literature = FactoryBot.create(:literature)
      get :edit, {:id => literature.to_param}
      expect(assigns(:literature)).to be_nil
    end
  end

  describe "POST create without admin_user" do
    describe "with valid params" do
      it "not creates a new Literature" do
        attributes = FactoryBot.attributes_for(:literature)
        expect {
        post :create, {:literature => attributes}
        }.not_to change(Literature, :count)
      end

      it "redirects to the created literature" do
        attributes = FactoryBot.attributes_for(:literature)
        post :create, {:literature => attributes}
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "POST create with admin_user", :admin_user_logged_in => true do
    describe "with valid params" do
      it "creates a new Literature" do
        attributes = FactoryBot.attributes_for(:literature)
        expect {
          post :create, {:literature => attributes}
        }.to change(Literature, :count).by(1)
      end

      it "assigns a newly created literature as @literature" do
        attributes = FactoryBot.attributes_for(:literature)
        post :create, {:literature => attributes}
        expect(assigns(:literature)).to be_a(Literature)
        expect(assigns(:literature)).to be_persisted
      end

      it "redirects to the created literature" do
        attributes = FactoryBot.attributes_for(:literature)
        post :create, {:literature => attributes}
        expect(response).to redirect_to(Literature.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved literature as @literature" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Literature).to receive(:save).and_return(false)
        post :create, {:literature => { "these" => "params" }}
        expect(assigns(:literature)).to be_a_new(Literature)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Literature).to receive(:save).and_return(false)
        post :create, {:literature => { "these" => "params"   }}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update without admin_user" do
    describe "with valid params" do
      it "updates the requested literature" do
        literature = FactoryBot.create(:literature)
        # Assuming there are no other literatures in the database, this
        # specifies that the Literature created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        expect_any_instance_of(Literature).not_to receive(:update_attributes).with({ "these" => "params" })
      end

      it "assigns the requested literature as @literature" do
        literature = FactoryBot.create(:literature)
        put :update, :id => literature.to_param, :literature => literature.attributes.slice(*@valid_attribute_names)
        expect(assigns(:literature)).to be_nil
      end

      it "redirects to the literature" do
        literature = FactoryBot.create(:literature)
        put :update, :id => literature.to_param, :literature => literature.attributes.slice(*@valid_attribute_names)
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "PUT update with admin_user", :admin_user_logged_in => true do
    describe "with valid params" do
      it "assigns the requested literature as @literature" do
        literature = FactoryBot.create(:literature)
        put :update, {:id => literature.to_param, :literature => literature.attributes.slice(*@valid_attribute_names)}
        expect(assigns(:literature)).to eq(literature)
      end

      it "redirects to the literature" do
        literature = FactoryBot.create(:literature)
        put :update, {:id => literature.to_param, :literature => literature.attributes.slice(*@valid_attribute_names)}
        expect(response).to redirect_to(literature)
      end
    end

    describe "with invalid params" do
      it "assigns the literature as @literature" do
        literature = FactoryBot.create(:literature)
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Literature).to receive(:save).and_return(false)
        put :update, {:id => literature.to_param, :literature => {  "these" => "params"  }}
        expect(assigns(:literature)).to eq(literature)
      end

      it "re-renders the 'edit' template" do
        literature = FactoryBot.create(:literature)
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Literature).to receive(:save).and_return(false)
        put :update, {:id => literature.to_param, :literature => {  "these" => "params"  }}
        expect(response).to render_template("edit") 
      end
    end
  end

  describe "DELETE destroy without admin_user" do
    it "not destroys the requested literature" do
      literature = FactoryBot.create(:literature)
      expect {
        delete :destroy, {:id => literature.to_param}
      }.not_to change(Literature, :count)
    end

    it "redirects to root" do
      literature = FactoryBot.create(:literature)
      delete :destroy, {:id => literature.to_param}
      expect(response).to redirect_to(root_url)
    end
  end

  describe "DELETE destroy with admin_user", :admin_user_logged_in => true do
    it "destroys the requested literature" do
      literature = FactoryBot.create(:literature)
      expect {
        delete :destroy, {:id => literature.to_param}
      }.to change(Literature, :count).by(-1)
    end

    it "redirects to the literatures list" do
      literature = FactoryBot.create(:literature)
      delete :destroy, {:id => literature.to_param}
      expect(response).to redirect_to(literatures_url)
    end
  end

end
