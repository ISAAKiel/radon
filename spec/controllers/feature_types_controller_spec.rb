require 'rails_helper'

describe FeatureTypesController, type: :controller do

  before(:all) do
    @valid_attribute_names = PermittedParams.new.feature_type_attributes.map(&:to_s)
  end

  before(:each, :admin_user_logged_in => true) do
    @admin_user = FactoryGirl.create(:admin_user)
    activate_authlogic
    UserSession.create(@admin_user)
  end

  describe "GET index" do
    it "assigns all feature_types as @feature_types" do
      feature_types = FactoryGirl.create_list(:feature_type,10)
      get :index, {}
      expect(assigns(:feature_types)).to match_array(feature_types)
    end
  end

  describe "GET show" do
    it "assigns the requested feature_type as @feature_type" do
      feature_type = FactoryGirl.create(:feature_type)
      get :show, {:id => feature_type.to_param}
      expect(assigns(:feature_type)).to eq(feature_type)
    end
  end

  describe "GET new" do

    it "not assigns a new feature_type as @feature_type without admin user" do
      get :new
      expect(assigns(:feature_type)).to be_nil
    end

    it "assigns a new feature_type as @feature_type with admin user", :admin_user_logged_in => true do
      get :new
      expect(assigns(:feature_type)).to be_a_new(FeatureType)
    end
  end

  describe "GET edit" do
    it "assigns the requested feature_type as @feature_type with admin user", :admin_user_logged_in => true do
      feature_type = FactoryGirl.create(:feature_type)
      get :edit, {:id => feature_type.to_param}
      expect(assigns(:feature_type)).to eq(feature_type)
    end
    it "assigns the requested feature_type as @feature_type" do
      feature_type = FactoryGirl.create(:feature_type)
      get :edit, {:id => feature_type.to_param}
      expect(assigns(:feature_type)).to be_nil
    end
  end

  describe "POST create without admin_user" do
    describe "with valid params" do
      it "not creates a new FeatureType" do
        attributes = FactoryGirl.attributes_for(:feature_type)
        expect {
        post :create, {:feature_type => attributes}
        }.not_to change(FeatureType, :count)
      end

      it "redirects to the created feature_type" do
        attributes = FactoryGirl.attributes_for(:feature_type)
        post :create, {:feature_type => attributes}
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "POST create with admin_user", :admin_user_logged_in => true do
    describe "with valid params" do
      it "creates a new FeatureType" do
        attributes = FactoryGirl.attributes_for(:feature_type)
        expect {
          post :create, {:feature_type => attributes}
        }.to change(FeatureType, :count).by(1)
      end

      it "assigns a newly created feature_type as @feature_type" do
        attributes = FactoryGirl.attributes_for(:feature_type)
        post :create, {:feature_type => attributes}
        expect(assigns(:feature_type)).to be_a(FeatureType)
        expect(assigns(:feature_type)).to be_persisted
      end

      it "redirects to the created feature_type" do
        attributes = FactoryGirl.attributes_for(:feature_type)
        post :create, {:feature_type => attributes}
        expect(response).to redirect_to(FeatureType.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved feature_type as @feature_type" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(FeatureType).to receive(:save).and_return(false)
        post :create, {:feature_type => { "these" => "params" }}
        expect(assigns(:feature_type)).to be_a_new(FeatureType)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(FeatureType).to receive(:save).and_return(false)
        post :create, {:feature_type => { "these" => "params" }}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update without admin_user" do
    describe "with valid params" do
      it "updates the requested feature_type" do
        feature_type = FactoryGirl.create(:feature_type)
        # Assuming there are no other feature_types in the database, this
        # specifies that the FeatureType created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        expect_any_instance_of(FeatureType).not_to receive(:update_attributes).with({ "these" => "params" })
      end

      it "assigns the requested feature_type as @feature_type" do
        feature_type = FactoryGirl.create(:feature_type)
        put :update, {:id => feature_type.to_param, :feature_type => feature_type.attributes.slice(*@valid_attribute_names)}
        expect(assigns(:feature_type)).to be_nil
      end

      it "redirects to the feature_type" do
        feature_type = FactoryGirl.create(:feature_type)
        put :update, {:id => feature_type.to_param, :feature_type => feature_type.attributes.slice(*@valid_attribute_names)}
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "PUT update with admin_user", :admin_user_logged_in => true do
    describe "with valid params" do
      it "assigns the requested feature_type as @feature_type" do
        feature_type = FactoryGirl.create(:feature_type)
        put :update, {:id => feature_type.to_param, :feature_type => feature_type.attributes.slice(*@valid_attribute_names)}
        expect(assigns(:feature_type)).to eq(feature_type)
      end

      it "redirects to the feature_type" do
        feature_type = FactoryGirl.create(:feature_type)
        put :update, {:id => feature_type.to_param, :feature_type => feature_type.attributes.slice(*@valid_attribute_names)}
        expect(response).to redirect_to(feature_type)
      end
    end

    describe "with invalid params" do
      it "assigns the feature_type as @feature_type" do
        feature_type = FactoryGirl.create(:feature_type)
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(FeatureType).to receive(:save).and_return(false)
        put :update, {:id => feature_type.to_param, :feature_type => { "these" => "params" }}
        expect(assigns(:feature_type)).to eq(feature_type)
      end

      it "re-renders the 'edit' template" do
        feature_type = FactoryGirl.create(:feature_type)
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(FeatureType).to receive(:save).and_return(false)
        put :update, {:id => feature_type.to_param, :feature_type => { "these" => "params" }}
        expect(response).to render_template("edit") 
      end
    end
  end

  describe "DELETE destroy without admin_user" do
    it "not destroys the requested feature_type" do
      feature_type = FactoryGirl.create(:feature_type)
      expect {
        delete :destroy, {:id => feature_type.to_param}
      }.not_to change(FeatureType, :count)
    end

    it "redirects to root" do
      feature_type = FactoryGirl.create(:feature_type)
      delete :destroy, {:id => feature_type.to_param}
      expect(response).to redirect_to(root_url)
    end
  end

  describe "DELETE destroy with admin_user", :admin_user_logged_in => true do
    it "destroys the requested feature_type" do
      feature_type = FactoryGirl.create(:feature_type)
      expect {
        delete :destroy, {:id => feature_type.to_param}
      }.to change(FeatureType, :count).by(-1)
    end

    it "redirects to the feature_types list" do
      feature_type = FactoryGirl.create(:feature_type)
      delete :destroy, {:id => feature_type.to_param}
      expect(response).to redirect_to(feature_types_url)
    end
  end

end
