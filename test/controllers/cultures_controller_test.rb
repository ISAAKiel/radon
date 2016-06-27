require 'test_helper'

class CulturesControllerTest < ActionController::TestCase
  setup do
    @culture = cultures(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cultures)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create culture" do
    assert_difference('Culture.count') do
      post :create, culture: { name: @culture.name, position: @culture.position }
    end

    assert_redirected_to culture_path(assigns(:culture))
  end

  test "should show culture" do
    get :show, id: @culture
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @culture
    assert_response :success
  end

  test "should update culture" do
    patch :update, id: @culture, culture: { name: @culture.name, position: @culture.position }
    assert_redirected_to culture_path(assigns(:culture))
  end

  test "should destroy culture" do
    assert_difference('Culture.count', -1) do
      delete :destroy, id: @culture
    end

    assert_redirected_to cultures_path
  end
end
