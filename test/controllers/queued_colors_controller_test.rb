require "test_helper"

describe QueuedColorsController do
  describe "index" do
    it "is a working route" do
      get queued_colors_url
      must_respond_with :success
    end

    it "returns json" do
      get queued_colors_url
      response.header["Content-Type"].must_include "json"
    end

    it "returns an Array of all queued colors" do
      get queued_colors_url
      body = JSON.parse(response.body)
      body.must_be_kind_of Array
      body.length.must_equal QueuedColor.count
    end

    it "returns an empty Array if there are no colors" do
      QueuedColor.destroy_all
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

    it "returns json" do
      get color_url
      response.header["Content-Type"].must_include "json"
    end

    it "returns the first queued color when queue is not empty" do
      get color_url
      body = JSON.parse(response.body)
      body.must_be_kind_of Hash
      body.must_include "color"
    end

    it "falls back to last displayed color when queue is empty" do
      QueuedColor.destroy_all
      get color_url
      # displayed_colors fixture data is present
      must_respond_with :success
      body = JSON.parse(response.body)
      body.must_include "color"
    end

    it "returns 404 when queue and history are both empty" do
      QueuedColor.destroy_all
      DisplayedColor.destroy_all
      get color_url
      must_respond_with :not_found
    end
  end

  describe "create" do
    it "creates a new queued color" do
      proc {
        post queued_colors_url, params: { color: "51, 51, 51" }
      }.must_change "QueuedColor.count", 1

      must_respond_with :success

      body = JSON.parse(response.body)
      body.must_be_kind_of Hash
      body.must_include "id"
      body.must_include "countdown"
      QueuedColor.find(body["id"]).color.must_equal "51, 51, 51"
    end

    it "returns bad_request for invalid color format" do
      proc {
        post queued_colors_url, params: { color: nil }
      }.wont_change "QueuedColor.count"

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
