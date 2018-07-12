require "test_helper"

describe DisplayedColor do
  let(:displayed_color) { DisplayedColor.new(color: "51, 51, 51") }

  it "must be valid" do
    value(displayed_color).must_be :valid?
  end

  it "must have a color" do
    # Given
    displayed_color.color = nil

    # Then
    value(displayed_color).wont_be :valid?
    displayed_color.errors.must_include :color
  end

  it "must have a color that is between 7 and 9 char in length" do
    displayed_color.color = "0, 0"
    value(displayed_color).wont_be :valid?

    displayed_color.color = "51, 51, 51, 0"
    value(displayed_color).wont_be :valid?
  end
end
