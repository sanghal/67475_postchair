require 'test_helper'

class InputStreamsControllerTest < ActionController::TestCase
  setup do
    @input_stream = input_streams(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:input_streams)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create input_stream" do
    assert_difference('InputStream.count') do
      post :create, input_stream: { input_time: @input_stream.input_time, measurement: @input_stream.measurement, position: @input_stream.position, user_id: @input_stream.user_id }
    end

    assert_redirected_to input_stream_path(assigns(:input_stream))
  end

  test "should show input_stream" do
    get :show, id: @input_stream
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @input_stream
    assert_response :success
  end

  test "should update input_stream" do
    patch :update, id: @input_stream, input_stream: { input_time: @input_stream.input_time, measurement: @input_stream.measurement, position: @input_stream.position, user_id: @input_stream.user_id }
    assert_redirected_to input_stream_path(assigns(:input_stream))
  end

  test "should destroy input_stream" do
    assert_difference('InputStream.count', -1) do
      delete :destroy, id: @input_stream
    end

    assert_redirected_to input_streams_path
  end
end
