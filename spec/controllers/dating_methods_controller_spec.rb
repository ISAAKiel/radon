require 'rails_helper'

describe DatingMethodsController, type: :controller do

  before(:all) do
    @valid_attribute_names = PermittedParams.new.dating_method_attributes.map(&:to_s)
  end

  before(:each, :admin_user_logged_in => true) do
    @admin_user = FactoryGirl.create(:admin_user)
    activate_authlogic
    UserSession.create(@admin_user)
  end

  describe "GET index" do
    context 'as admin user', :admin_user_logged_in => true do
      it "assigns all dating_methods as @dating_methods" do
        dating_methods = FactoryGirl.create_list(:dating_method,10)
        get :index, {}
        expect(assigns(:dating_methods)).to match_array(dating_methods)
      end
    end
    context 'not as admin user' do
      it "assigns all dating_methods as @dating_methods" do
        dating_methods = FactoryGirl.create_list(:dating_method,10)
        get :index, {}
        expect(assigns(:dating_methods)).not_to match_array(dating_methods)
      end
    end
  end

  describe "GET show" do
    it "assigns the requested dating_method as @dating_method" do
      dating_method = FactoryGirl.create(:dating_method)
      get :show, {:id => dating_method.to_param}
      expect(assigns(:dating_method)).to eq(dating_method)
    end
  end

  describe "GET new" do

    it "not assigns a new dating_method as @dating_method without admin user" do
      get :new
      expect(assigns(:dating_method)).to be_nil
    end

    it "assigns a new dating_method as @dating_method with admin user", :admin_user_logged_in => true do
      get :new
      expect(assigns(:dating_method)).to be_a_new(DatingMethod)
    end
  end

  describe "GET edit" do
    it "assigns the requested dating_method as @dating_method with admin user", :admin_user_logged_in => true do
      dating_method = FactoryGirl.create(:dating_method)
      get :edit, {:id => dating_method.to_param}
      expect(assigns(:dating_method)).to eq(dating_method)
    end
    it "assigns the requested dating_method as @dating_method" do
      dating_method = FactoryGirl.create(:dating_method)
      get :edit, {:id => dating_method.to_param}
      expect(assigns(:dating_method)).to be_nil
    end
  end

  describe "POST create without admin_user" do
    describe "with valid params" do
      it "not creates a new DatingMethod" do
        attributes = FactoryGirl.attributes_for(:dating_method)
        expect {
        post :create, {:dating_method => attributes}
        }.not_to change(DatingMethod, :count)
      end

      it "redirects to the created dating_method" do
        attributes = FactoryGirl.attributes_for(:dating_method)
        post :create, {:dating_method => attributes}
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "POST create with admin_user", :admin_user_logged_in => true do
    describe "with valid params" do
      it "creates a new DatingMethod" do
        attributes = FactoryGirl.attributes_for(:dating_method)
        expect {
          post :create, {:dating_method => attributes}
        }.to change(DatingMethod, :count).by(1)
      end

      it "assigns a newly created dating_method as @dating_method" do
        attributes = FactoryGirl.attributes_for(:dating_method)
        post :create, {:dating_method => attributes}
        expect(assigns(:dating_method)).to be_a(DatingMethod)
        expect(assigns(:dating_method)).to be_persisted
      end

      it "redirects to the created dating_method" do
        attributes = FactoryGirl.attributes_for(:dating_method)
        post :create, {:dating_method => attributes}
        expect(response).to redirect_to(DatingMethod.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved dating_method as @dating_method" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(DatingMethod).to receive(:save).and_return(false)
        post :create, {:dating_method => { "these" => "params" }}
        expect(assigns(:dating_method)).to be_a_new(DatingMethod)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(DatingMethod).to receive(:save).and_return(false)
        post :create, {:dating_method => { "these" => "params" }}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update without admin_user" do
    describe "with valid params" do
      it "updates the requested dating_method" do
        dating_method = FactoryGirl.create(:dating_method)
        # Assuming there are no other dating_methods in the database, this
        # specifies that the DatingMethod created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        expect_any_instance_of(DatingMethod).not_to receive(:update_attributes).with({ "these" => "params" })
      end

      it "assigns the requested dating_method as @dating_method" do
        dating_method = FactoryGirl.create(:dating_method)
        put :update, {:id => dating_method.to_param, :dating_method => dating_method.attributes.slice(*@valid_attribute_names)}
        expect(assigns(:dating_method)).to be_nil
      end

      it "redirects to the dating_method" do
        dating_method = FactoryGirl.create(:dating_method)
        put :update, {:id => dating_method.to_param, :dating_method => dating_method.attributes.slice(*@valid_attribute_names)}
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "PUT update with admin_user", :admin_user_logged_in => true do
    describe "with valid params" do
      it "assigns the requested dating_method as @dating_method" do
        dating_method = FactoryGirl.create(:dating_method)
        put :update, {:id => dating_method.to_param, :dating_method => dating_method.attributes.slice(*@valid_attribute_names)}
        expect(assigns(:dating_method)).to eq(dating_method)
      end

      it "redirects to the dating_method" do
        dating_method = FactoryGirl.create(:dating_method)
        put :update, {:id => dating_method.to_param, :dating_method => dating_method.attributes.slice(*@valid_attribute_names)}
        expect(response).to redirect_to(dating_method)
      end
    end

    describe "with invalid params" do
      it "assigns the dating_method as @dating_method" do
        dating_method = FactoryGirl.create(:dating_method)
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(DatingMethod).to receive(:save).and_return(false)
        put :update, {:id => dating_method.to_param, :dating_method => { "these" => "params" }}
        expect(assigns(:dating_method)).to eq(dating_method)
      end

      it "re-renders the 'edit' template" do
        dating_method = FactoryGirl.create(:dating_method)
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(DatingMethod).to receive(:save).and_return(false)
        put :update, {:id => dating_method.to_param, :dating_method => { "these" => "params" }}
        expect(response).to render_template("edit") 
      end
    end
  end

  describe "DELETE destroy without admin_user" do
    it "not destroys the requested dating_method" do
      dating_method = FactoryGirl.create(:dating_method)
      expect {
        delete :destroy, {:id => dating_method.to_param}
      }.not_to change(DatingMethod, :count)
    end

    it "redirects to root" do
      dating_method = FactoryGirl.create(:dating_method)
      delete :destroy, {:id => dating_method.to_param}
      expect(response).to redirect_to(root_url)
    end
  end

  describe "DELETE destroy with admin_user", :admin_user_logged_in => true do
    it "destroys the requested dating_method" do
      dating_method = FactoryGirl.create(:dating_method)
      expect {
        delete :destroy, {:id => dating_method.to_param}
      }.to change(DatingMethod, :count).by(-1)
    end

    it "redirects to the dating_methods list" do
      dating_method = FactoryGirl.create(:dating_method)
      delete :destroy, {:id => dating_method.to_param}
      expect(response).to redirect_to(dating_methods_url)
    end
  end

end
