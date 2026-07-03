require "test_helper"

describe QueuedColor do
  before do
    QueuedColor.destroy_all
    DisplayedColor.destroy_all
  end

  let(:queued_color) { QueuedColor.new(color: "51, 51, 51") }

  it "must be valid" do
    value(queued_color).must_be :valid?
  end

  it "must have a color" do
    queued_color.color = nil
    value(queued_color).wont_be :valid?
    queued_color.errors.must_include :color
  end

  it "must have a color in RGB format" do
    queued_color.color = "not-a-color"
    value(queued_color).wont_be :valid?
    queued_color.errors.must_include :color
  end

  describe "countdown_time" do
    it "returns BUFFER_MS for an unsaved color" do
      fresh = QueuedColor.new(color: "10, 10, 10")
      fresh.countdown_time.must_equal QueuedColor::BUFFER_MS
    end

    it "returns 0 when first color is overdue" do
      # Last display was over a full duration ago — first color is past due
      DisplayedColor.create!(color: "0, 0, 0", created_at: 1.minute.ago)
      a = QueuedColor.create!(color: "1, 1, 1")
      a.countdown_time.must_equal 0
    end

    it "adds one duration per position ahead in the queue" do
      DisplayedColor.create!(color: "0, 0, 0", created_at: 1.minute.ago)
      QueuedColor.create!(color: "1, 1, 1")  # position 0
      b = QueuedColor.create!(color: "2, 2, 2")  # position 1
      duration_ms = (QueuedColor::DURATION_TIME * 1000) + QueuedColor::BUFFER_MS
      b.countdown_time.must_equal duration_ms
    end

    it "must respond to countdown_time" do
      queued_color.must_respond_to :countdown_time
    end
  end
end
