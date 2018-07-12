require "test_helper"

describe QueuedColor do
  let(:queued_color) { QueuedColor.new(color: "51, 51, 51") }

  it "must be valid" do
    value(queued_color).must_be :valid?
  end

  it "must have a color" do
    # Given
    queued_color.color = nil

    # Then
    value(queued_color).wont_be :valid?
    queued_color.errors.must_include :color
  end

  it "must have a color that is between 7 and 9 char in length" do
    queued_color.color = "0, 0"
    value(queued_color).wont_be :valid?

    queued_color.color = "51, 51, 51, 0"
    value(queued_color).wont_be :valid?
  end
end
