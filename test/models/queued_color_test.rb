require "test_helper"

class QueuedColorTest < ActiveSupport::TestCase
  describe QueuedColor do
    let(:queued_color) { QueuedColor.new color: "51, 51, 51" }

    it "must be valid" do
      value(queued_color).must_be :valid?
    end

    it "must have a color" do
      # Given
      displayed_color.color = nil

      # Then
      displayed_color.valid?.must_equal false
      displayed_color.errors.must_include :color
    end
  end
end
