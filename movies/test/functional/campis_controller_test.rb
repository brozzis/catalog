require 'test_helper'

class CampisControllerTest < ActionController::TestCase
  setup do
    @campi = campis(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:campis)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create campi" do
    assert_difference('Campi.count') do
      post :create, :campi => @campi.attributes
    end

    assert_redirected_to campi_path(assigns(:campi))
  end

  test "should show campi" do
    get :show, :id => @campi.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @campi.to_param
    assert_response :success
  end

  test "should update campi" do
    put :update, :id => @campi.to_param, :campi => @campi.attributes
    assert_redirected_to campi_path(assigns(:campi))
  end

  test "should destroy campi" do
    assert_difference('Campi.count', -1) do
      delete :destroy, :id => @campi.to_param
    end

    assert_redirected_to campis_path
  end
end
