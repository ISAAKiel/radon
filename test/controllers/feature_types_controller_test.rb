require 'test_helper'

class FeatureTypesControllerTest < ActionController::TestCase
  setup do
    @feature_type = feature_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:feature_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create feature_type" do
    assert_difference('FeatureType.count') do
      post :create, feature_type: { comment: @feature_type.comment, name: @feature_type.name, position: @feature_type.position }
    end

    assert_redirected_to feature_type_path(assigns(:feature_type))
  end

  test "should show feature_type" do
    get :show, id: @feature_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @feature_type
    assert_response :success
  end

  test "should update feature_type" do
    patch :update, id: @feature_type, feature_type: { comment: @feature_type.comment, name: @feature_type.name, position: @feature_type.position }
    assert_redirected_to feature_type_path(assigns(:feature_type))
  end

  test "should destroy feature_type" do
    assert_difference('FeatureType.count', -1) do
      delete :destroy, id: @feature_type
    end

    assert_redirected_to feature_types_path
  end
end
