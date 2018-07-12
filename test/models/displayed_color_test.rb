require "test_helper"

describe DisplayedColor do
  let(:displayed_color) { DisplayedColor.new }

  it "must be valid" do
    value(displayed_color).must_be :valid?
  end
end
