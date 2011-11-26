require 'test_helper'

class GrowthsControllerTest < ActionController::TestCase
  setup do
    @growth = growths(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:growths)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create growth" do
    assert_difference('Growth.count') do
      post :create, growth: @growth.attributes
    end

    assert_redirected_to growth_path(assigns(:growth))
  end

  test "should show growth" do
    get :show, id: @growth.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @growth.to_param
    assert_response :success
  end

  test "should update growth" do
    put :update, id: @growth.to_param, growth: @growth.attributes
    assert_redirected_to growth_path(assigns(:growth))
  end

  test "should destroy growth" do
    assert_difference('Growth.count', -1) do
      delete :destroy, id: @growth.to_param
    end

    assert_redirected_to growths_path
  end
end
