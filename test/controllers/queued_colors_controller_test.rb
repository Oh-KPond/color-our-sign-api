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
      get color_url

      must_respond_with :success
    end

    it "return json" do
      get color_url

      response.header['Content-Type'].must_include "json"
    end

    it "returns an string" do
      get color_url

      body = response.body
      body.must_be_kind_of String
    end

    it "returns null if there are no queued_colors" do
      QueuedColor.all.each do |entry|
        entry.destroy
      end

      get color_url

      body = JSON.parse(response.body)
      body.must_be_nil
    end

    describe "create" do

    it "should get create" do
      post queued_colors_url, params: { color: "51, 51, 51" }

      must_respond_with :success
    end

    it "creates a new queued color" do
      proc {
        post queued_colors_url, params: { color: "51, 51, 51" }
      }.must_change 'QueuedColor.count', 1

      must_respond_with :success

      body = JSON.parse(response.body)
      body.must_be_kind_of Hash
      body.must_include "id"

      # Check that the ID matches
      QueuedColor.find(body["id"]).color.must_equal "51, 51, 51"
    end

    it "returns a bad_request for bad params data" do
      proc {
        post queued_colors_url, params: {color: nil}
      }.wont_change 'QueuedColor.count'

      must_respond_with :bad_request

      body = JSON.parse(response.body)
      body.must_be_kind_of Hash
      body.must_include "ok"
      body["ok"].must_equal false
      body.must_include "errors"
      body["errors"].must_include "color"

    end
  end
  end
end
