require 'test_helper'

class SamplesControllerTest < ActionController::TestCase
  setup do
    @sample = samples(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:samples)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sample" do
    assert_difference('Sample.count') do
      post :create, sample: { approved: @sample.approved, bp: @sample.bp, comment: @sample.comment, contact_e_mail: @sample.contact_e_mail, creator_ip: @sample.creator_ip, dating_method_id: @sample.dating_method_id, delta_13_c: @sample.delta_13_c, delta_13_c_std: @sample.delta_13_c_std, feature: @sample.feature, feature_type_id: @sample.feature_type_id, lab_id: @sample.lab_id, lab_nr: @sample.lab_nr, phase_id: @sample.phase_id, prmat_comment: @sample.prmat_comment, prmat_id: @sample.prmat_id, right_id: @sample.right_id, site_id: @sample.site_id, std: @sample.std }
    end

    assert_redirected_to sample_path(assigns(:sample))
  end

  test "should show sample" do
    get :show, id: @sample
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sample
    assert_response :success
  end

  test "should update sample" do
    patch :update, id: @sample, sample: { approved: @sample.approved, bp: @sample.bp, comment: @sample.comment, contact_e_mail: @sample.contact_e_mail, creator_ip: @sample.creator_ip, dating_method_id: @sample.dating_method_id, delta_13_c: @sample.delta_13_c, delta_13_c_std: @sample.delta_13_c_std, feature: @sample.feature, feature_type_id: @sample.feature_type_id, lab_id: @sample.lab_id, lab_nr: @sample.lab_nr, phase_id: @sample.phase_id, prmat_comment: @sample.prmat_comment, prmat_id: @sample.prmat_id, right_id: @sample.right_id, site_id: @sample.site_id, std: @sample.std }
    assert_redirected_to sample_path(assigns(:sample))
  end

  test "should destroy sample" do
    assert_difference('Sample.count', -1) do
      delete :destroy, id: @sample
    end

    assert_redirected_to samples_path
  end
end
