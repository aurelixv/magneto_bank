require 'test_helper'

class ImgSignalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @img_signal = img_signals(:one)
  end

  test "should get index" do
    get img_signals_url
    assert_response :success
  end

  test "should get new" do
    get new_img_signal_url
    assert_response :success
  end

  test "should create img_signal" do
    assert_difference('ImgSignal.count') do
      post img_signals_url, params: { img_signal: {  } }
    end

    assert_redirected_to img_signal_url(ImgSignal.last)
  end

  test "should show img_signal" do
    get img_signal_url(@img_signal)
    assert_response :success
  end

  test "should get edit" do
    get edit_img_signal_url(@img_signal)
    assert_response :success
  end

  test "should update img_signal" do
    patch img_signal_url(@img_signal), params: { img_signal: {  } }
    assert_redirected_to img_signal_url(@img_signal)
  end

  test "should destroy img_signal" do
    assert_difference('ImgSignal.count', -1) do
      delete img_signal_url(@img_signal)
    end

    assert_redirected_to img_signals_url
  end
end
