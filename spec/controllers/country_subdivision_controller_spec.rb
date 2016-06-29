require 'rails_helper'

describe CountrySubdivisionsController, type: :controller do

  before(:all) do
    @valid_attribute_names = PermittedParams.new.country_subdivision_attributes.map(&:to_s)
  end

  before(:each, :admin_user_logged_in => true) do
    @admin_user = FactoryGirl.create(:admin_user)
    activate_authlogic
    UserSession.create(@admin_user)
  end

  describe "GET index" do
    it "assigns all country_subdivisions as @country_subdivisions" do
      country_subdivisions = FactoryGirl.create_list(:country_subdivision,3)
      get :index, {}
      expect(assigns(:country_subdivisions)).to match_array(country_subdivisions)
    end
  end

  describe "GET show" do
    it "assigns the requested country_subdivision as @country_subdivision" do
      country_subdivision = FactoryGirl.create(:country_subdivision)
      get :show, {:id => country_subdivision.to_param}
      expect(assigns(:country_subdivision)).to eq(country_subdivision)
    end
  end

  describe "GET new" do

    it "not assigns a new country_subdivision as @country_subdivision without admin user" do
      get :new
      expect(assigns(:country_subdivision)).to be_nil
    end

    it "assigns a new country_subdivision as @country_subdivision with admin user", :admin_user_logged_in => true do
      get :new
      expect(assigns(:country_subdivision)).to be_a_new(CountrySubdivision)
    end
  end

  describe "GET edit" do
    it "assigns the requested country_subdivision as @country_subdivision with admin user", :admin_user_logged_in => true do
      country_subdivision = FactoryGirl.create(:country_subdivision)
      get :edit, {:id => country_subdivision.to_param}
      expect(assigns(:country_subdivision)).to eq(country_subdivision)
    end
    it "assigns the requested country_subdivision as @country_subdivision" do
      country_subdivision = FactoryGirl.create(:country_subdivision)
      get :edit, {:id => country_subdivision.to_param}
      expect(assigns(:country_subdivision)).to be_nil
    end
  end

  describe "POST create without admin_user" do
    describe "with valid params" do
      it "not creates a new CountrySubdivision" do
        attributes = FactoryGirl.attributes_for(:country_subdivision)
        expect {
        post :create, {:country_subdivision => attributes}
        }.not_to change(CountrySubdivision, :count)
      end

      it "redirects to the created country_subdivision" do
        attributes = FactoryGirl.attributes_for(:country_subdivision)
        post :create, {:country_subdivision => attributes}
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "POST create with admin_user", :admin_user_logged_in => true do
    describe "with valid params" do
      it "creates a new CountrySubdivision" do
        attributes = FactoryGirl.attributes_for(:country_subdivision)
        expect {
          post :create, {:country_subdivision => attributes}
        }.to change(CountrySubdivision, :count).by(1)
      end

      it "assigns a newly created country_subdivision as @country_subdivision" do
        attributes = FactoryGirl.attributes_for(:country_subdivision)
        post :create, {:country_subdivision => attributes}
        expect(assigns(:country_subdivision)).to be_a(CountrySubdivision)
        expect(assigns(:country_subdivision)).to be_persisted
      end

      it "redirects to the created country_subdivision" do
        attributes = FactoryGirl.attributes_for(:country_subdivision)
        post :create, {:country_subdivision => attributes}
        expect(response).to redirect_to(CountrySubdivision.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved country_subdivision as @country_subdivision" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(CountrySubdivision).to receive(:save).and_return(false)
        post :create, {:country_subdivision => { "these" => "params"  }}
        expect(assigns(:country_subdivision)).to be_a_new(CountrySubdivision)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(CountrySubdivision).to receive(:save).and_return(false)
        post :create, {:country_subdivision => { "these" => "params"  }}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update without admin_user" do
    describe "with valid params" do
      it "updates the requested country_subdivision" do
        country_subdivision = FactoryGirl.create(:country_subdivision)
        # Assuming there are no other country_subdivisions in the database, this
        # specifies that the CountrySubdivision created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        expect_any_instance_of(CountrySubdivision).not_to receive(:update_attributes).with({ "these" => "params" })
      end

      it "assigns the requested country_subdivision as @country_subdivision" do
        country_subdivision = FactoryGirl.create(:country_subdivision)
        put :update, {:id => country_subdivision.to_param, :country_subdivision => country_subdivision.attributes.slice(*@valid_attribute_names)}
        expect(assigns(:country_subdivision)).to be_nil
      end

      it "redirects to the country_subdivision" do
        country_subdivision = FactoryGirl.create(:country_subdivision)
        put :update, {:id => country_subdivision.to_param, :country_subdivision => country_subdivision.attributes.slice(*@valid_attribute_names)}
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "PUT update with admin_user", :admin_user_logged_in => true do
    describe "with valid params" do
      it "assigns the requested country_subdivision as @country_subdivision" do
        country_subdivision = FactoryGirl.create(:country_subdivision)
        put :update, {:id => country_subdivision.to_param, :country_subdivision => country_subdivision.attributes.slice(*@valid_attribute_names)}
        expect(assigns(:country_subdivision)).to eq(country_subdivision)
      end

      it "redirects to the country_subdivision" do
        country_subdivision = FactoryGirl.create(:country_subdivision)
        put :update, {:id => country_subdivision.to_param, :country_subdivision => country_subdivision.attributes.slice(*@valid_attribute_names)}
        expect(response).to redirect_to(country_subdivision)
      end
    end

    describe "with invalid params" do
      it "assigns the country_subdivision as @country_subdivision" do
        country_subdivision = FactoryGirl.create(:country_subdivision)
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(CountrySubdivision).to receive(:save).and_return(false)
        put :update, {:id => country_subdivision.to_param, :country_subdivision => { "these" => "params"  }}
        expect(assigns(:country_subdivision)).to eq(country_subdivision)
      end

      it "re-renders the 'edit' template" do
        country_subdivision = FactoryGirl.create(:country_subdivision)
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(CountrySubdivision).to receive(:save).and_return(false)
        put :update, {:id => country_subdivision.to_param, :country_subdivision => { "these" => "params"  }}
        expect(response).to render_template("edit") 
      end
    end
  end

  describe "DELETE destroy without admin_user" do
    it "not destroys the requested country_subdivision" do
      country_subdivision = FactoryGirl.create(:country_subdivision)
      expect {
        delete :destroy, {:id => country_subdivision.to_param}
      }.not_to change(CountrySubdivision, :count)
    end

    it "redirects to root" do
      country_subdivision = FactoryGirl.create(:country_subdivision)
      delete :destroy, {:id => country_subdivision.to_param}
      expect(response).to redirect_to(root_url)
    end
  end

  describe "DELETE destroy with admin_user", :admin_user_logged_in => true do
    it "destroys the requested country_subdivision" do
      country_subdivision = FactoryGirl.create(:country_subdivision)
      expect {
        delete :destroy, {:id => country_subdivision.to_param}
      }.to change(CountrySubdivision, :count).by(-1)
    end

    it "redirects to the country_subdivisions list" do
      country_subdivision = FactoryGirl.create(:country_subdivision)
      delete :destroy, {:id => country_subdivision.to_param}
      expect(response).to redirect_to(country_subdivisions_url)
    end
  end

end
