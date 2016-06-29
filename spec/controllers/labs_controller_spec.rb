require 'rails_helper'

describe LabsController, type: :controller do

  before(:all) do
    @valid_attribute_names = PermittedParams.new.lab_attributes.map(&:to_s)
  end

  before(:each, :admin_user_logged_in => true) do
    @admin_user = FactoryGirl.create(:admin_user)
    activate_authlogic
    UserSession.create(@admin_user)
  end

  describe "GET index" do
    it "assigns all labs as @labs" do
      labs = FactoryGirl.create_list(:lab,10)
      get :index, {}
      expect(assigns(:labs)).to match_array(labs)
    end
  end

  describe "GET show" do
    it "assigns the requested lab as @lab" do
      lab = FactoryGirl.create(:lab)
      get :show, {:id => lab.to_param}
      expect(assigns(:lab)).to eq(lab)
    end
  end

  describe "GET new" do

    it "not assigns a new lab as @lab without admin user" do
      get :new
      expect(assigns(:lab)).to be_nil
    end

    it "assigns a new lab as @lab with admin user", :admin_user_logged_in => true do
      get :new
      expect(assigns(:lab)).to be_a_new(Lab)
    end
  end

  describe "GET edit" do
    it "assigns the requested lab as @lab with admin user", :admin_user_logged_in => true do
      lab = FactoryGirl.create(:lab)
      get :edit, {:id => lab.to_param}
      expect(assigns(:lab)).to eq(lab)
    end
    it "assigns the requested lab as @lab" do
      lab = FactoryGirl.create(:lab)
      get :edit, {:id => lab.to_param}
      expect(assigns(:lab)).to be_nil
    end
  end

  describe "POST create without admin_user" do
    describe "with valid params" do
      it "not creates a new Lab" do
        attributes = FactoryGirl.attributes_for(:lab)
        expect {
        post :create, {:lab => attributes}
        }.not_to change(Lab, :count)
      end

      it "redirects to the created lab" do
        attributes = FactoryGirl.attributes_for(:lab)
        post :create, {:lab => attributes}
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "POST create with admin_user", :admin_user_logged_in => true do
    describe "with valid params" do
      it "creates a new Lab" do
        attributes = FactoryGirl.attributes_for(:lab)
        expect {
          post :create, {:lab => attributes}
        }.to change(Lab, :count).by(1)
      end

      it "assigns a newly created lab as @lab" do
        attributes = FactoryGirl.attributes_for(:lab)
        post :create, {:lab => attributes}
        expect(assigns(:lab)).to be_a(Lab)
        expect(assigns(:lab)).to be_persisted
      end

      it "redirects to the created lab" do
        attributes = FactoryGirl.attributes_for(:lab)
        post :create, {:lab => attributes}
        expect(response).to redirect_to(Lab.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved lab as @lab" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Lab).to receive(:save).and_return(false)
        post :create, {:lab => { "these" => "params" }}
        expect(assigns(:lab)).to be_a_new(Lab)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Lab).to receive(:save).and_return(false)
        post :create, {:lab => { "these" => "params" }}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update without admin_user" do
    describe "with valid params" do
      it "updates the requested lab" do
        lab = FactoryGirl.create(:lab)
        # Assuming there are no other labs in the database, this
        # specifies that the Lab created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        expect_any_instance_of(Lab).not_to receive(:update_attributes).with({ "these" => "params" })
      end

      it "assigns the requested lab as @lab" do
        lab = FactoryGirl.create(:lab)
        put :update, {:id => lab.to_param, :lab => lab.attributes.slice(*@valid_attribute_names)}
        expect(assigns(:lab)).to be_nil
      end

      it "redirects to the lab" do
        lab = FactoryGirl.create(:lab)
        put :update, {:id => lab.to_param, :lab => lab.attributes.slice(*@valid_attribute_names)}
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "PUT update with admin_user", :admin_user_logged_in => true do
    describe "with valid params" do
      it "assigns the requested lab as @lab" do
        lab = FactoryGirl.create(:lab)
        put :update, {:id => lab.to_param, :lab => lab.attributes.slice(*@valid_attribute_names)}
        expect(assigns(:lab)).to eq(lab)
      end

      it "redirects to the lab" do
        lab = FactoryGirl.create(:lab)
        put :update, {:id => lab.to_param, :lab => lab.attributes.slice(*@valid_attribute_names)}
        expect(response).to redirect_to(lab)
      end
    end

    describe "with invalid params" do
      it "assigns the lab as @lab" do
        lab = FactoryGirl.create(:lab)
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Lab).to receive(:save).and_return(false)
        put :update, {:id => lab.to_param, :lab => { "these" => "params" }}
        expect(assigns(:lab)).to eq(lab)
      end

      it "re-renders the 'edit' template" do
        lab = FactoryGirl.create(:lab)
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Lab).to receive(:save).and_return(false)
        put :update, {:id => lab.to_param, :lab => { "these" => "params" }}
        expect(response).to render_template("edit") 
      end
    end
  end

  describe "DELETE destroy without admin_user" do
    it "not destroys the requested lab" do
      lab = FactoryGirl.create(:lab)
      expect {
        delete :destroy, {:id => lab.to_param}
      }.not_to change(Lab, :count)
    end

    it "redirects to root" do
      lab = FactoryGirl.create(:lab)
      delete :destroy, {:id => lab.to_param}
      expect(response).to redirect_to(root_url)
    end
  end

  describe "DELETE destroy with admin_user", :admin_user_logged_in => true do
    it "destroys the requested lab" do
      lab = FactoryGirl.create(:lab)
      expect {
        delete :destroy, {:id => lab.to_param}
      }.to change(Lab, :count).by(-1)
    end

    it "redirects to the labs list" do
      lab = FactoryGirl.create(:lab)
      delete :destroy, {:id => lab.to_param}
      expect(response).to redirect_to(labs_url)
    end
  end

end
