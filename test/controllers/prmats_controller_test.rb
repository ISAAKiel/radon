require 'test_helper'

class PrmatsControllerTest < ActionController::TestCase
  setup do
    @prmat = prmats(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:prmats)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create prmat" do
    assert_difference('Prmat.count') do
      post :create, prmat: { name: @prmat.name, position: @prmat.position }
    end

    assert_redirected_to prmat_path(assigns(:prmat))
  end

  test "should show prmat" do
    get :show, id: @prmat
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @prmat
    assert_response :success
  end

  test "should update prmat" do
    patch :update, id: @prmat, prmat: { name: @prmat.name, position: @prmat.position }
    assert_redirected_to prmat_path(assigns(:prmat))
  end

  test "should destroy prmat" do
    assert_difference('Prmat.count', -1) do
      delete :destroy, id: @prmat
    end

    assert_redirected_to prmats_path
  end
end
