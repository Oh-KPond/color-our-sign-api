require "test_helper"

describe DisplayNextColorJob do
  before do
    QueuedColor.destroy_all
    DisplayedColor.destroy_all
  end

  it "moves the first queued color into displayed_colors" do
    QueuedColor.create!(color: "5, 5, 5")
    assert_difference "DisplayedColor.count", 1 do
      DisplayNextColorJob.perform_now
    end
    QueuedColor.count.must_equal 0
    DisplayedColor.last.color.must_equal "5, 5, 5"
  end

  it "is a no-op when the queue is empty" do
    assert_no_difference "DisplayedColor.count" do
      DisplayNextColorJob.perform_now
    end
  end

  it "displays colors in order" do
    QueuedColor.create!(color: "1, 1, 1", created_at: 2.seconds.ago)
    QueuedColor.create!(color: "2, 2, 2", created_at: 1.second.ago)
    DisplayNextColorJob.perform_now
    DisplayedColor.last.color.must_equal "1, 1, 1"
    QueuedColor.count.must_equal 1
  end
end
