require 'test_helper'

class DatingMethodsControllerTest < ActionController::TestCase
  setup do
    @dating_method = dating_methods(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dating_methods)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dating_method" do
    assert_difference('DatingMethod.count') do
      post :create, dating_method: { name: @dating_method.name, position: @dating_method.position }
    end

    assert_redirected_to dating_method_path(assigns(:dating_method))
  end

  test "should show dating_method" do
    get :show, id: @dating_method
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @dating_method
    assert_response :success
  end

  test "should update dating_method" do
    patch :update, id: @dating_method, dating_method: { name: @dating_method.name, position: @dating_method.position }
    assert_redirected_to dating_method_path(assigns(:dating_method))
  end

  test "should destroy dating_method" do
    assert_difference('DatingMethod.count', -1) do
      delete :destroy, id: @dating_method
    end

    assert_redirected_to dating_methods_path
  end
end
