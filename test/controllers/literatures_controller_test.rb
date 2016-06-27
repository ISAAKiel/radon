require 'test_helper'

class LiteraturesControllerTest < ActionController::TestCase
  setup do
    @literature = literatures(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:literatures)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create literature" do
    assert_difference('Literature.count') do
      post :create, literature: { approved: @literature.approved, author: @literature.author, bibtex: @literature.bibtex, long_citation: @literature.long_citation, short_citation: @literature.short_citation, url: @literature.url, year: @literature.year }
    end

    assert_redirected_to literature_path(assigns(:literature))
  end

  test "should show literature" do
    get :show, id: @literature
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @literature
    assert_response :success
  end

  test "should update literature" do
    patch :update, id: @literature, literature: { approved: @literature.approved, author: @literature.author, bibtex: @literature.bibtex, long_citation: @literature.long_citation, short_citation: @literature.short_citation, url: @literature.url, year: @literature.year }
    assert_redirected_to literature_path(assigns(:literature))
  end

  test "should destroy literature" do
    assert_difference('Literature.count', -1) do
      delete :destroy, id: @literature
    end

    assert_redirected_to literatures_path
  end
end
