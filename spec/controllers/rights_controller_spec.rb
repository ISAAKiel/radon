require 'rails_helper'

describe RightsController, type: :controller do

  before(:all) do
    @valid_attribute_names = PermittedParams.new.right_attributes.map(&:to_s)
  end

  before(:each, :admin_user_logged_in => true) do
    @admin_user = FactoryBot.create(:admin_user)
    activate_authlogic
    UserSession.create(@admin_user)
  end

  describe "GET index" do
    context 'as admin user', :admin_user_logged_in => true do
      it "assigns all rights as @rights" do
        rights = FactoryBot.create_list(:right,10)
        get :index, {}
        expect(assigns(:rights)).to match_array(rights)
      end
    end

    context 'not as admin user' do
      it "assigns all rights as @rights" do
        rights = FactoryBot.create_list(:right,10)
        get :index, {}
        expect(assigns(:rights)).not_to match_array(rights)
      end
    end
  end

  describe "GET show" do
    it "assigns the requested right as @right" do
      right = FactoryBot.create(:right)
      get :show, {:id => right.to_param}
      expect(assigns(:right)).to eq(right)
    end
  end

  describe "GET new" do

    it "not assigns a new right as @right without admin user" do
      get :new
      expect(assigns(:right)).to be_nil
    end

    it "assigns a new right as @right with admin user", :admin_user_logged_in => true do
      get :new
      expect(assigns(:right)).to be_a_new(Right)
    end
  end

  describe "GET edit" do
    it "assigns the requested right as @right with admin user", :admin_user_logged_in => true do
      right = FactoryBot.create(:right)
      get :edit, {:id => right.to_param}
      expect(assigns(:right)).to eq(right)
    end
    it "assigns the requested right as @right" do
      right = FactoryBot.create(:right)
      get :edit, {:id => right.to_param}
      expect(assigns(:right)).to be_nil
    end
  end

  describe "POST create without admin_user" do
    describe "with valid params" do
      it "not creates a new Right" do
        attributes = FactoryBot.attributes_for(:right)
        expect {
        post :create, {:right => attributes}
        }.not_to change(Right, :count)
      end

      it "redirects to the created right" do
        attributes = FactoryBot.attributes_for(:right)
        post :create, {:right => attributes}
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "POST create with admin_user", :admin_user_logged_in => true do
    describe "with valid params" do
      it "creates a new Right" do
        attributes = FactoryBot.attributes_for(:right)
        expect {
          post :create, {:right => attributes}
        }.to change(Right, :count).by(1)
      end

      it "assigns a newly created right as @right" do
        attributes = FactoryBot.attributes_for(:right)
        post :create, {:right => attributes}
        expect(assigns(:right)).to be_a(Right)
        expect(assigns(:right)).to be_persisted
      end

      it "redirects to the created right" do
        attributes = FactoryBot.attributes_for(:right)
        post :create, {:right => attributes}
        expect(response).to redirect_to(Right.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved right as @right" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Right).to receive(:save).and_return(false)
        post :create, {:right => { "these" => "params" }}
        expect(assigns(:right)).to be_a_new(Right)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Right).to receive(:save).and_return(false)
        post :create, {:right => { "these" => "params" }}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update without admin_user" do
    describe "with valid params" do
      it "updates the requested right" do
        right = FactoryBot.create(:right)
        # Assuming there are no other rights in the database, this
        # specifies that the Right created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        expect_any_instance_of(Right).not_to receive(:update_attributes).with({ "these" => "params" })
      end

      it "assigns the requested right as @right" do
        right = FactoryBot.create(:right)
        put :update, {:id => right.to_param, :right => right.attributes.slice(*@valid_attribute_names)}
        expect(assigns(:right)).to be_nil
      end

      it "redirects to the right" do
        right = FactoryBot.create(:right)
        put :update, {:id => right.to_param, :right => right.attributes.slice(*@valid_attribute_names)}
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "PUT update with admin_user", :admin_user_logged_in => true do
    describe "with valid params" do
      it "assigns the requested right as @right" do
        right = FactoryBot.create(:right)
        put :update, {:id => right.to_param, :right => right.attributes.slice(*@valid_attribute_names)}
        expect(assigns(:right)).to eq(right)
      end

      it "redirects to the right" do
        right = FactoryBot.create(:right)
        put :update, {:id => right.to_param, :right => right.attributes.slice(*@valid_attribute_names)}
        expect(response).to redirect_to(right)
      end
    end

    describe "with invalid params" do
      it "assigns the right as @right" do
        right = FactoryBot.create(:right)
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Right).to receive(:save).and_return(false)
        put :update, {:id => right.to_param, :right => { "these" => "params" }}
        expect(assigns(:right)).to eq(right)
      end

      it "re-renders the 'edit' template" do
        right = FactoryBot.create(:right)
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Right).to receive(:save).and_return(false)
        put :update, {:id => right.to_param, :right => { "these" => "params" }}
        expect(response).to render_template("edit") 
      end
    end
  end

  describe "DELETE destroy without admin_user" do
    it "not destroys the requested right" do
      right = FactoryBot.create(:right)
      expect {
        delete :destroy, {:id => right.to_param}
      }.not_to change(Right, :count)
    end

    it "redirects to root" do
      right = FactoryBot.create(:right)
      delete :destroy, {:id => right.to_param}
      expect(response).to redirect_to(root_url)
    end
  end

  describe "DELETE destroy with admin_user", :admin_user_logged_in => true do
    it "destroys the requested right" do
      right = FactoryBot.create(:right)
      expect {
        delete :destroy, {:id => right.to_param}
      }.to change(Right, :count).by(-1)
    end

    it "redirects to the rights list" do
      right = FactoryBot.create(:right)
      delete :destroy, {:id => right.to_param}
      expect(response).to redirect_to(rights_url)
    end
  end

end
