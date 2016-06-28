require 'spec_helper'
require 'wice_grid'

describe SamplesController, type: :controller do

  before(:all) do
    @valid_attribute_names = PermittedParams.new.sample_attributes.map(&:to_s)
  end

  before(:each, :admin_user_logged_in => true) do
    @admin_user = FactoryGirl.create(:admin_user)
    activate_authlogic
    UserSession.create(@admin_user)
  end

  describe "GET index" do

    it "assigns all samples with right_id 1 as @samples" do
      FactoryGirl.create(:right, id: 1)
      samples = FactoryGirl.create_list(:sample,2, right_id: 1)
      get :index, {}
      expect(assigns(:samples_grid).resultset).to match_array(samples)
    end

    it "not assigns all samples without right_id 1 as @samples" do
      FactoryGirl.create(:right)
      FactoryGirl.create(:right)
      samples = FactoryGirl.create_list(:sample,2, right_id: 2)
      get :index, {}
      expect(assigns(:samples_grid).resultset).not_to match_array(samples)
    end
  end

  describe "GET show" do
    it "assigns the requested sample as @sample" do
      sample = FactoryGirl.create(:sample)
      get :show, {:id => sample.to_param}
      expect(assigns(:sample)).to eq(sample)
    end
  end

  describe "GET new" do

    it "not assigns a new sample as @sample without admin user" do
      get :new
      expect(assigns(:sample)).to be_nil
    end

    it "assigns a new sample as @sample with admin user", :admin_user_logged_in => true do
      get :new
      expect(assigns(:sample)).to be_a_new(Sample)
    end
  end

  describe "GET edit" do
    it "assigns the requested sample as @sample with admin user", :admin_user_logged_in => true do
      sample = FactoryGirl.create(:sample)
      get :edit, {:id => sample.to_param}
      expect(assigns(:sample)).to eq(sample)
    end
    it "assigns the requested sample as @sample" do
      sample = FactoryGirl.create(:sample)
      get :edit, {:id => sample.to_param}
      expect(assigns(:sample)).to be_nil
    end
  end

  describe "POST create without admin_user" do
    describe "with valid params" do
      it "not creates a new Sample" do
        attributes = FactoryGirl.attributes_for(:sample)
        expect {
        post :create, {:sample => attributes}
        }.not_to change(Sample, :count)
      end

      it "redirects to the root" do
        attributes = FactoryGirl.attributes_for(:sample)
        post :create, {:sample => attributes}
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "POST create with admin_user", :admin_user_logged_in => true do
    describe "with valid params" do
      it "creates a new Sample" do
        attributes = FactoryGirl.build(:sample).attributes.slice(*@valid_attribute_names)
        expect {
          post :create, {:sample => attributes}
        }.to change(Sample.unscoped, :count).by(1)
      end

      it "assigns a newly created sample as @sample" do
        attributes = FactoryGirl.build(:sample).attributes.slice(*@valid_attribute_names)
        post :create, {:sample => attributes}
        expect(assigns(:sample)).to be_a(Sample)
        expect(assigns(:sample)).to be_persisted
      end

      it "redirects to the created sample" do
        attributes = FactoryGirl.build(:sample).attributes.slice(*@valid_attribute_names)
        post :create, {:sample => attributes}
        expect(response).to redirect_to(Sample.unscoped.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved sample as @sample" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Sample).to receive(:save).and_return(false)
        post :create, {:sample => { "these" => "params" }}
        expect(assigns(:sample)).to be_a_new(Sample)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Sample).to receive(:save).and_return(false)
        post :create, {:sample => { "these" => "params" }}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update without admin_user" do
    describe "with valid params" do
      it "updates the requested sample" do
        sample = FactoryGirl.create(:sample)
        # Assuming there are no other samples in the database, this
        # specifies that the Sample created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        expect_any_instance_of(Sample).not_to receive(:update_attributes).with({ "these" => "params" })
      end

      it "assigns the requested sample as @sample" do
        sample = FactoryGirl.create(:sample)
        put :update, {:id => sample.to_param, :sample => sample.attributes.slice(*@valid_attribute_names)}
        expect(assigns(:sample)).to be_nil
      end

      it "redirects to root" do
        sample = FactoryGirl.create(:sample)
        put :update, {:id => sample.to_param, :sample => sample.attributes.slice(*@valid_attribute_names)}
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "PUT update with admin_user", :admin_user_logged_in => true do
    describe "with valid params" do
      it "assigns the requested sample as @sample" do
        sample = FactoryGirl.create(:sample)
        sample_attributes = FactoryGirl.attributes_for(:sample)
        put :update, {:id => sample.to_param, :sample => sample_attributes}
        expect(assigns(:sample)).to eq(sample)
      end

      it "redirects to the sample" do
        sample = FactoryGirl.create(:sample)
        sample_attributes = FactoryGirl.attributes_for(:sample)
        put :update, {:id => sample.to_param, :sample => sample_attributes}
        expect(response).to redirect_to(sample)
      end
    end

    describe "with invalid params" do
      it "assigns the sample as @sample" do
        sample = FactoryGirl.create(:sample)
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Sample).to receive(:save).and_return(false)
        put :update, {:id => sample.to_param, :sample => { "these" => "params" }}
        expect(assigns(:sample)).to eq(sample)
      end

      it "re-renders the 'edit' template" do
        sample = FactoryGirl.create(:sample)
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Sample).to receive(:save).and_return(false)
        put :update, {:id => sample.to_param, :sample => { "these" => "params" }}
        expect(response).to render_template("edit") 
      end
    end
  end

  describe "DELETE destroy without admin_user" do
    it "not destroys the requested sample" do
      sample = FactoryGirl.create(:sample)
      expect {
        delete :destroy, {:id => sample.to_param}
      }.not_to change(Sample.unscoped, :count)
    end

    it "redirects to root" do
      sample = FactoryGirl.create(:sample)
      delete :destroy, {:id => sample.to_param}
      expect(response).to redirect_to(root_url)
    end
  end

  describe "DELETE destroy with admin_user", :admin_user_logged_in => true do
    it "destroys the requested sample" do
      sample = FactoryGirl.create(:sample)
      expect {
        delete :destroy, {:id => sample.to_param}
      }.to change(Sample, :count).by(-1)
    end

    it "redirects to the samples list" do
      sample = FactoryGirl.create(:sample)
      delete :destroy, {:id => sample.to_param}
      expect(response).to redirect_to(samples_url)
    end
  end

end
