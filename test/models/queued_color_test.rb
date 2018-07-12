require "test_helper"

describe QueuedColor do
  let(:queued_color) { QueuedColor.new }

  it "must be valid" do
    value(queued_color).must_be :valid?
  end
end
