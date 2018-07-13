require "test_helper"

describe QueuedColorsController do
  describe "index" do
    it "is a working route" do
      get queued_colors_url

      must_respond_with :success
    end

    it "return json" do
      get queued_colors_url

      response.header['Content-Type'].must_include "json"
    end

    it "returns an Array of all Customers" do
      get queued_colors_url

      body = JSON.parse(response.body)
      body.must_be_kind_of Array
      body.length.must_equal QueuedColor.count
    end

    it "returns an empty Array if there are no colors" do
      QueuedColor.all.each do |entry|
        entry.destroy
      end

      get queued_colors_url

      body = JSON.parse(response.body)
      body.must_be :empty?
    end
  end

  describe "color" do
    it "is a working route" do
      get color

      must_respond_with :success
    end

    it "return json" do
      get color

      response.header['Content-Type'].must_include "json"
    end

    it "returns an string" do
      get color

      body = JSON.parse(response.body)
      body.must_be_kind_of Hash
    end

    it "returns null if there are no queued_colors" do
      QueuedColor.all.each do |entry|
        entry.destroy
      end

      get queued_colors_url

      body = JSON.parse(response.body)
      body.must_be_nil
    end
  end
end
