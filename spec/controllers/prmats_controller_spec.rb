require 'rails_helper'

describe PrmatsController, type: :controller do

  before(:all) do
    @valid_attribute_names = PermittedParams.new.prmat_attributes.map(&:to_s)
  end

  before(:each, :admin_user_logged_in => true) do
    @admin_user = FactoryGirl.create(:admin_user)
    activate_authlogic
    UserSession.create(@admin_user)
  end

  describe "GET index" do
    it "assigns all prmats as @prmats" do
      prmats = FactoryGirl.create_list(:prmat,10)
      get :index, {}
      expect(assigns(:prmats)).to match_array(prmats)
    end
  end

  describe "GET show" do
    it "assigns the requested prmat as @prmat" do
      prmat = FactoryGirl.create(:prmat)
      get :show, {:id => prmat.to_param}
      expect(assigns(:prmat)).to eq(prmat)
    end
  end

  describe "GET new" do

    it "not assigns a new prmat as @prmat without admin user" do
      get :new
      expect(assigns(:prmat)).to be_nil
    end

    it "assigns a new prmat as @prmat with admin user", :admin_user_logged_in => true do
      get :new
      expect(assigns(:prmat)).to be_a_new(Prmat)
    end
  end

  describe "GET edit" do
    it "assigns the requested prmat as @prmat with admin user", :admin_user_logged_in => true do
      prmat = FactoryGirl.create(:prmat)
      get :edit, {:id => prmat.to_param}
      expect(assigns(:prmat)).to eq(prmat)
    end
    it "assigns the requested prmat as @prmat" do
      prmat = FactoryGirl.create(:prmat)
      get :edit, {:id => prmat.to_param}
      expect(assigns(:prmat)).to be_nil
    end
  end

  describe "POST create without admin_user" do
    describe "with valid params" do
      it "not creates a new Prmat" do
        attributes = FactoryGirl.attributes_for(:prmat)
        expect {
        post :create, {:prmat => attributes}
        }.not_to change(Prmat, :count)
      end

      it "redirects to the created prmat" do
        attributes = FactoryGirl.attributes_for(:prmat)
        post :create, {:prmat => attributes}
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "POST create with admin_user", :admin_user_logged_in => true do
    describe "with valid params" do
      it "creates a new Prmat" do
        attributes = FactoryGirl.attributes_for(:prmat)
        expect {
          post :create, {:prmat => attributes}
        }.to change(Prmat, :count).by(1)
      end

      it "assigns a newly created prmat as @prmat" do
        attributes = FactoryGirl.attributes_for(:prmat)
        post :create, {:prmat => attributes}
        expect(assigns(:prmat)).to be_a(Prmat)
        expect(assigns(:prmat)).to be_persisted
      end

      it "redirects to the created prmat" do
        attributes = FactoryGirl.attributes_for(:prmat)
        post :create, {:prmat => attributes}
        expect(response).to redirect_to(Prmat.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved prmat as @prmat" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Prmat).to receive(:save).and_return(false)
        post :create, {:prmat => {"these" => "params"   }}
        expect(assigns(:prmat)).to be_a_new(Prmat)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Prmat).to receive(:save).and_return(false)
        post :create, {:prmat => { "these" => "params"  }}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update without admin_user" do
    describe "with valid params" do
      it "updates the requested prmat" do
        prmat = FactoryGirl.create(:prmat)
        # Assuming there are no other prmats in the database, this
        # specifies that the Prmat created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        expect_any_instance_of(Prmat).not_to receive(:update_attributes).with({ "these" => "params" })
      end

      it "assigns the requested prmat as @prmat" do
        prmat = FactoryGirl.create(:prmat)
        put :update, {:id => prmat.to_param, :prmat => prmat.attributes.slice(*@valid_attribute_names)}
        expect(assigns(:prmat)).to be_nil
      end

      it "redirects to the prmat" do
        prmat = FactoryGirl.create(:prmat)
        put :update, {:id => prmat.to_param, :prmat => prmat.attributes.slice(*@valid_attribute_names)}
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "PUT update with admin_user", :admin_user_logged_in => true do
    describe "with valid params" do
      it "assigns the requested prmat as @prmat" do
        prmat = FactoryGirl.create(:prmat)
        put :update, {:id => prmat.to_param, :prmat => prmat.attributes.slice(*@valid_attribute_names)}
        expect(assigns(:prmat)).to eq(prmat)
      end

      it "redirects to the prmat" do
        prmat = FactoryGirl.create(:prmat)
        put :update, {:id => prmat.to_param, :prmat => prmat.attributes.slice(*@valid_attribute_names)}
        expect(response).to redirect_to(prmat)
      end
    end

    describe "with invalid params" do
      it "assigns the prmat as @prmat" do
        prmat = FactoryGirl.create(:prmat)
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Prmat).to receive(:save).and_return(false)
        put :update, {:id => prmat.to_param, :prmat => { "these" => "params"  }}
        expect(assigns(:prmat)).to eq(prmat)
      end

      it "re-renders the 'edit' template" do
        prmat = FactoryGirl.create(:prmat)
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Prmat).to receive(:save).and_return(false)
        put :update, {:id => prmat.to_param, :prmat => { "these" => "params"  }}
        expect(response).to render_template("edit") 
      end
    end
  end

  describe "DELETE destroy without admin_user" do
    it "not destroys the requested prmat" do
      prmat = FactoryGirl.create(:prmat)
      expect {
        delete :destroy, {:id => prmat.to_param}
      }.not_to change(Prmat, :count)
    end

    it "redirects to root" do
      prmat = FactoryGirl.create(:prmat)
      delete :destroy, {:id => prmat.to_param}
      expect(response).to redirect_to(root_url)
    end
  end

  describe "DELETE destroy with admin_user", :admin_user_logged_in => true do
    it "destroys the requested prmat" do
      prmat = FactoryGirl.create(:prmat)
      expect {
        delete :destroy, {:id => prmat.to_param}
      }.to change(Prmat, :count).by(-1)
    end

    it "redirects to the prmats list" do
      prmat = FactoryGirl.create(:prmat)
      delete :destroy, {:id => prmat.to_param}
      expect(response).to redirect_to(prmats_url)
    end
  end

end
