require 'test_helper'

class NewestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @newest = newests(:one)
  end

  test "should get index" do
    get newests_url
    assert_response :success
  end

  test "should get new" do
    get new_newest_url
    assert_response :success
  end

  test "should create newest" do
    assert_difference('Newest.count') do
      post newests_url, params: { newest: {  } }
    end

    assert_redirected_to newest_url(Newest.last)
  end

  test "should show newest" do
    get newest_url(@newest)
    assert_response :success
  end

  test "should get edit" do
    get edit_newest_url(@newest)
    assert_response :success
  end

  test "should update newest" do
    patch newest_url(@newest), params: { newest: {  } }
    assert_redirected_to newest_url(@newest)
  end

  test "should destroy newest" do
    assert_difference('Newest.count', -1) do
      delete newest_url(@newest)
    end

    assert_redirected_to newests_url
  end
end
