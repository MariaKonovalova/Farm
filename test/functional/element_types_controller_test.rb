require 'test_helper'

class ElementTypesControllerTest < ActionController::TestCase
  setup do
    @element_type = element_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:element_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create element_type" do
    assert_difference('ElementType.count') do
      post :create, element_type: @element_type.attributes
    end

    assert_redirected_to element_type_path(assigns(:element_type))
  end

  test "should show element_type" do
    get :show, id: @element_type.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @element_type.to_param
    assert_response :success
  end

  test "should update element_type" do
    put :update, id: @element_type.to_param, element_type: @element_type.attributes
    assert_redirected_to element_type_path(assigns(:element_type))
  end

  test "should destroy element_type" do
    assert_difference('ElementType.count', -1) do
      delete :destroy, id: @element_type.to_param
    end

    assert_redirected_to element_types_path
  end
end
