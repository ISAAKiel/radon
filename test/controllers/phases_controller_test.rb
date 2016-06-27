require 'test_helper'

class PhasesControllerTest < ActionController::TestCase
  setup do
    @phase = phases(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:phases)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create phase" do
    assert_difference('Phase.count') do
      post :create, phase: { approved: @phase.approved, culture_id: @phase.culture_id, name: @phase.name, position: @phase.position }
    end

    assert_redirected_to phase_path(assigns(:phase))
  end

  test "should show phase" do
    get :show, id: @phase
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @phase
    assert_response :success
  end

  test "should update phase" do
    patch :update, id: @phase, phase: { approved: @phase.approved, culture_id: @phase.culture_id, name: @phase.name, position: @phase.position }
    assert_redirected_to phase_path(assigns(:phase))
  end

  test "should destroy phase" do
    assert_difference('Phase.count', -1) do
      delete :destroy, id: @phase
    end

    assert_redirected_to phases_path
  end
end
