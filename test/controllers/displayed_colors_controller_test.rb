require "test_helper"

describe DisplayedColorsController do
  describe "index" do
    it "is a working route" do
      get displayed_colors_url
      must_respond_with :success
    end

    it "returns json" do
      get displayed_colors_url
      response.header["Content-Type"].must_include "json"
    end

    it "returns an Array of displayed colors in reverse chronological order" do
      get displayed_colors_url
      body = JSON.parse(response.body)
      body.must_be_kind_of Array
      body.length.must_equal DisplayedColor.count
    end

    it "returns empty Array when no colors have been displayed" do
      DisplayedColor.destroy_all
      get displayed_colors_url
      body = JSON.parse(response.body)
      body.must_be :empty?
    end
  end
end
