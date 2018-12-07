require "application_system_test_case"

class ImgSignalsTest < ApplicationSystemTestCase
  setup do
    @img_signal = img_signals(:one)
  end

  test "visiting the index" do
    visit img_signals_url
    assert_selector "h1", text: "Img Signals"
  end

  test "creating a Img signal" do
    visit img_signals_url
    click_on "New Img Signal"

    click_on "Create Img signal"

    assert_text "Img signal was successfully created"
    click_on "Back"
  end

  test "updating a Img signal" do
    visit img_signals_url
    click_on "Edit", match: :first

    click_on "Update Img signal"

    assert_text "Img signal was successfully updated"
    click_on "Back"
  end

  test "destroying a Img signal" do
    visit img_signals_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Img signal was successfully destroyed"
  end
end
