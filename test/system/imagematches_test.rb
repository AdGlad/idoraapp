require "application_system_test_case"

class ImagematchesTest < ApplicationSystemTestCase
  setup do
    @imagematch = imagematches(:one)
  end

  test "visiting the index" do
    visit imagematches_url
    assert_selector "h1", text: "Imagematches"
  end

  test "creating a Imagematch" do
    visit imagematches_url
    click_on "New Imagematch"

    fill_in "Desc", with: @imagematch.desc
    fill_in "Image", with: @imagematch.image_id
    fill_in "Name", with: @imagematch.name
    fill_in "Resp", with: @imagematch.resp
    click_on "Create Imagematch"

    assert_text "Imagematch was successfully created"
    click_on "Back"
  end

  test "updating a Imagematch" do
    visit imagematches_url
    click_on "Edit", match: :first

    fill_in "Desc", with: @imagematch.desc
    fill_in "Image", with: @imagematch.image_id
    fill_in "Name", with: @imagematch.name
    fill_in "Resp", with: @imagematch.resp
    click_on "Update Imagematch"

    assert_text "Imagematch was successfully updated"
    click_on "Back"
  end

  test "destroying a Imagematch" do
    visit imagematches_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Imagematch was successfully destroyed"
  end
end
