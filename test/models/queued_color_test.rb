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

  # it "must have a color that is between 7 and 10 char in length" do
  #   queued_color.color = "0, 0"
  #   value(queued_color).wont_be :valid?
  #
  #   queued_color.color = "51, 51, 51, 0"
  #   value(queued_color).wont_be :valid?
  # end
  # TODO: Readd length validation when input length is known

  describe "countdown_time" do
    it "Should exist" do
      queued_color.must_respond_to :countdown_time
    end

    it "should return the correct amount of time" do
      # Given - 4 entries in the queued_color table see test/fixtures
      # When - countdown_time calculated
      # Then - countdown_time must be equal to 60000
      queued_color.countdown_time.must_equal 60000
    end

    it "should return 0 if there are less than 2 entries" do
      QueuedColor.destroy_all

      queued_color.countdown_time.must_equal 0
    end

  end

end
