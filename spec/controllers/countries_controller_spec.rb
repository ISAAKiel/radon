require 'rails_helper'

describe CountriesController, type: :controller do

  before(:all) do
    @valid_attribute_names = PermittedParams.new.country_attributes.map(&:to_s)
  end

  before(:each, :admin_user_logged_in => true) do
    @admin_user = FactoryGirl.create(:admin_user)
    activate_authlogic
    UserSession.create(@admin_user)
  end

  describe "GET index" do
    it "assigns all countries as @countries" do
      countries = FactoryGirl.create_list(:country,10)
      get :index, {}
      expect(assigns(:countries)).to match_array(countries)
    end
  end

  describe "GET show" do
    it "assigns the requested country as @country" do
      country = FactoryGirl.create(:country)
      get :show, {:id => country.to_param}
      expect(assigns(:country)).to eq(country)
    end
  end

  describe "GET new" do

    it "not assigns a new country as @country without admin user" do
      get :new
      expect(assigns(:country)).to be_nil
    end

    it "assigns a new country as @country with admin user", :admin_user_logged_in => true do
      get :new
      expect(assigns(:country)).to be_a_new(Country)
    end
  end

  describe "GET edit" do
    it "assigns the requested country as @country with admin user", :admin_user_logged_in => true do
      country = FactoryGirl.create(:country)
      get :edit, {:id => country.to_param}
      expect(assigns(:country)).to eq(country)
    end
    it "assigns the requested country as @country" do
      country = FactoryGirl.create(:country)
      get :edit, {:id => country.to_param}
      expect(assigns(:country)).to be_nil
    end
  end

  describe "POST create without admin_user" do
    describe "with valid params" do
      it "not creates a new Country" do
        attributes = FactoryGirl.attributes_for(:country)
        expect {
        post :create, {:country => attributes}
        }.not_to change(Country, :count)
      end

      it "redirects to the created country" do
        attributes = FactoryGirl.attributes_for(:country)
        post :create, {:country => attributes}
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "POST create with admin_user", :admin_user_logged_in => true do
    describe "with valid params" do
      it "creates a new Country" do
        attributes = FactoryGirl.attributes_for(:country)
        expect {
          post :create, {:country => attributes}
        }.to change(Country, :count).by(1)
      end

      it "assigns a newly created country as @country" do
        attributes = FactoryGirl.attributes_for(:country)
        post :create, {:country => attributes}
        expect(assigns(:country)).to be_a(Country)
        expect(assigns(:country)).to be_persisted
      end

      it "redirects to the created country" do
        attributes = FactoryGirl.attributes_for(:country)
        post :create, {:country => attributes}
        expect(response).to redirect_to(Country.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved country as @country" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Country).to receive(:save).and_return(false)
        post :create, {:country => { "these" => "params" }}
        expect(assigns(:country)).to be_a_new(Country)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Country).to receive(:save).and_return(false)
        post :create, {:country => { "these" => "params"   }}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update without admin_user" do
    describe "with valid params" do
      it "updates the requested country" do
        country = FactoryGirl.create(:country)
        # Assuming there are no other countries in the database, this
        # specifies that the Country created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        expect_any_instance_of(Country).not_to receive(:update_attributes).with({ "these" => "params" })
      end

      it "assigns the requested country as @country" do
        country = FactoryGirl.create(:country)
        put :update, :id => country.to_param, :country => country.attributes.slice(*@valid_attribute_names)
        expect(assigns(:country)).to be_nil
      end

      it "redirects to the country" do
        country = FactoryGirl.create(:country)
        put :update, :id => country.to_param, :country => country.attributes.slice(*@valid_attribute_names)
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "PUT update with admin_user", :admin_user_logged_in => true do
    describe "with valid params" do
      it "assigns the requested country as @country" do
        country = FactoryGirl.create(:country)
        put :update, {:id => country.to_param, :country => country.attributes.slice(*@valid_attribute_names)}
        expect(assigns(:country)).to eq(country)
      end

      it "redirects to the country" do
        country = FactoryGirl.create(:country)
        put :update, {:id => country.to_param, :country => country.attributes.slice(*@valid_attribute_names)}
        expect(response).to redirect_to(country)
      end
    end

    describe "with invalid params" do
      it "assigns the country as @country" do
        country = FactoryGirl.create(:country)
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Country).to receive(:save).and_return(false)
        put :update, {:id => country.to_param, :country => {  "these" => "params"  }}
        expect(assigns(:country)).to eq(country)
      end

      it "re-renders the 'edit' template" do
        country = FactoryGirl.create(:country)
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Country).to receive(:save).and_return(false)
        put :update, {:id => country.to_param, :country => {  "these" => "params"  }}
        expect(response).to render_template("edit") 
      end
    end
  end

  describe "DELETE destroy without admin_user" do
    it "not destroys the requested country" do
      country = FactoryGirl.create(:country)
      expect {
        delete :destroy, {:id => country.to_param}
      }.not_to change(Country, :count)
    end

    it "redirects to root" do
      country = FactoryGirl.create(:country)
      delete :destroy, {:id => country.to_param}
      expect(response).to redirect_to(root_url)
    end
  end

  describe "DELETE destroy with admin_user", :admin_user_logged_in => true do
    it "destroys the requested country" do
      country = FactoryGirl.create(:country)
      expect {
        delete :destroy, {:id => country.to_param}
      }.to change(Country, :count).by(-1)
    end

    it "redirects to the countries list" do
      country = FactoryGirl.create(:country)
      delete :destroy, {:id => country.to_param}
      expect(response).to redirect_to(countries_url)
    end
  end

end
