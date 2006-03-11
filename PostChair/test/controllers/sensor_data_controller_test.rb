require 'test_helper'

class SensorDataControllerTest < ActionController::TestCase
  setup do
    @sensor_datum = sensor_data(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sensor_data)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sensor_datum" do
    assert_difference('SensorDatum.count') do
      post :create, sensor_datum: { measurement: @sensor_datum.measurement, position: @sensor_datum.position, time: @sensor_datum.time, user_id_id: @sensor_datum.user_id_id }
    end

    assert_redirected_to sensor_datum_path(assigns(:sensor_datum))
  end

  test "should show sensor_datum" do
    get :show, id: @sensor_datum
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sensor_datum
    assert_response :success
  end

  test "should update sensor_datum" do
    patch :update, id: @sensor_datum, sensor_datum: { measurement: @sensor_datum.measurement, position: @sensor_datum.position, time: @sensor_datum.time, user_id_id: @sensor_datum.user_id_id }
    assert_redirected_to sensor_datum_path(assigns(:sensor_datum))
  end

  test "should destroy sensor_datum" do
    assert_difference('SensorDatum.count', -1) do
      delete :destroy, id: @sensor_datum
    end

    assert_redirected_to sensor_data_path
  end
end
