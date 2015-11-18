require 'test_helper'

class ManagerAssociationsControllerTest < ActionController::TestCase
  setup do
    @manager_association = manager_associations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:manager_associations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create manager_association" do
    assert_difference('ManagerAssociation.count') do
      post :create, manager_association: { active: @manager_association.active, boolean: @manager_association.boolean, employee_id: @manager_association.employee_id, manager_id: @manager_association.manager_id }
    end

    assert_redirected_to manager_association_path(assigns(:manager_association))
  end

  test "should show manager_association" do
    get :show, id: @manager_association
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @manager_association
    assert_response :success
  end

  test "should update manager_association" do
    patch :update, id: @manager_association, manager_association: { active: @manager_association.active, boolean: @manager_association.boolean, employee_id: @manager_association.employee_id, manager_id: @manager_association.manager_id }
    assert_redirected_to manager_association_path(assigns(:manager_association))
  end

  test "should destroy manager_association" do
    assert_difference('ManagerAssociation.count', -1) do
      delete :destroy, id: @manager_association
    end

    assert_redirected_to manager_associations_path
  end
end
