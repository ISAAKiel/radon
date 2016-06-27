require 'test_helper'

class CountrySubdivisionsControllerTest < ActionController::TestCase
  setup do
    @country_subdivision = country_subdivisions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:country_subdivisions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create country_subdivision" do
    assert_difference('CountrySubdivision.count') do
      post :create, country_subdivision: { country_id: @country_subdivision.country_id, name: @country_subdivision.name, position: @country_subdivision.position }
    end

    assert_redirected_to country_subdivision_path(assigns(:country_subdivision))
  end

  test "should show country_subdivision" do
    get :show, id: @country_subdivision
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @country_subdivision
    assert_response :success
  end

  test "should update country_subdivision" do
    patch :update, id: @country_subdivision, country_subdivision: { country_id: @country_subdivision.country_id, name: @country_subdivision.name, position: @country_subdivision.position }
    assert_redirected_to country_subdivision_path(assigns(:country_subdivision))
  end

  test "should destroy country_subdivision" do
    assert_difference('CountrySubdivision.count', -1) do
      delete :destroy, id: @country_subdivision
    end

    assert_redirected_to country_subdivisions_path
  end
end
