require 'test_helper'

class GrowthStagesControllerTest < ActionController::TestCase
  setup do
    @growth_stage = growth_stages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:growth_stages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create growth_stage" do
    assert_difference('GrowthStage.count') do
      post :create, growth_stage: @growth_stage.attributes
    end

    assert_redirected_to growth_stage_path(assigns(:growth_stage))
  end

  test "should show growth_stage" do
    get :show, id: @growth_stage.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @growth_stage.to_param
    assert_response :success
  end

  test "should update growth_stage" do
    put :update, id: @growth_stage.to_param, growth_stage: @growth_stage.attributes
    assert_redirected_to growth_stage_path(assigns(:growth_stage))
  end

  test "should destroy growth_stage" do
    assert_difference('GrowthStage.count', -1) do
      delete :destroy, id: @growth_stage.to_param
    end

    assert_redirected_to growth_stages_path
  end
end
