require 'test_helper'

class LiteraturesSamplesControllerTest < ActionController::TestCase
  setup do
    @literatures_sample = literatures_samples(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:literatures_samples)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create literatures_sample" do
    assert_difference('LiteraturesSample.count') do
      post :create, literatures_sample: { literature_id: @literatures_sample.literature_id, pages: @literatures_sample.pages, sample_id: @literatures_sample.sample_id }
    end

    assert_redirected_to literatures_sample_path(assigns(:literatures_sample))
  end

  test "should show literatures_sample" do
    get :show, id: @literatures_sample
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @literatures_sample
    assert_response :success
  end

  test "should update literatures_sample" do
    patch :update, id: @literatures_sample, literatures_sample: { literature_id: @literatures_sample.literature_id, pages: @literatures_sample.pages, sample_id: @literatures_sample.sample_id }
    assert_redirected_to literatures_sample_path(assigns(:literatures_sample))
  end

  test "should destroy literatures_sample" do
    assert_difference('LiteraturesSample.count', -1) do
      delete :destroy, id: @literatures_sample
    end

    assert_redirected_to literatures_samples_path
  end
end
