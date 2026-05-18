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

  it "must have a color in RGB format" do
    displayed_color.color = "not-a-color"
    value(displayed_color).wont_be :valid?
    displayed_color.errors.must_include :color
  end

  it "prunes history to MAX_HISTORY entries on create" do
    DisplayedColor.destroy_all
    (DisplayedColor::MAX_HISTORY + 5).times do |i|
      DisplayedColor.create!(color: "#{i % 256}, 0, 0")
    end
    DisplayedColor.count.must_equal DisplayedColor::MAX_HISTORY
  end
end
