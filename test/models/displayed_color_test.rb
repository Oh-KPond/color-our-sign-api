require "test_helper"

class DisplayedColorTest < ActiveSupport::TestCase
  describe DisplayedColor do
    let(:displayed_color) { DisplayedColor.new color: "51, 51, 51"}

    it "must be valid" do
      value(displayed_color).must_be :valid?
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
