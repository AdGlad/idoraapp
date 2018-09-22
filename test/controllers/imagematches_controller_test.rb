require 'test_helper'

class ImagematchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @imagematch = imagematches(:one)
  end

  test "should get index" do
    get imagematches_url
    assert_response :success
  end

  test "should get new" do
    get new_imagematch_url
    assert_response :success
  end

  test "should create imagematch" do
    assert_difference('Imagematch.count') do
      post imagematches_url, params: { imagematch: { desc: @imagematch.desc, image_id: @imagematch.image_id, name: @imagematch.name, resp: @imagematch.resp } }
    end

    assert_redirected_to imagematch_url(Imagematch.last)
  end

  test "should show imagematch" do
    get imagematch_url(@imagematch)
    assert_response :success
  end

  test "should get edit" do
    get edit_imagematch_url(@imagematch)
    assert_response :success
  end

  test "should update imagematch" do
    patch imagematch_url(@imagematch), params: { imagematch: { desc: @imagematch.desc, image_id: @imagematch.image_id, name: @imagematch.name, resp: @imagematch.resp } }
    assert_redirected_to imagematch_url(@imagematch)
  end

  test "should destroy imagematch" do
    assert_difference('Imagematch.count', -1) do
      delete imagematch_url(@imagematch)
    end

    assert_redirected_to imagematches_url
  end
end
