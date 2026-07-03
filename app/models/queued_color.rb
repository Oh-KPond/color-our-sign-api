class QueuedColor < ApplicationRecord
  DURATION_TIME  = 10    # seconds per color
  BUFFER_MS      = 2000  # 2s processing buffer added to displayed time
  MAX_QUEUE_SIZE = 50    # reject POSTs when queue is at or above this size

  validates :color, presence: true
  validates :color, format: { with: /\A\d{1,3},\s?\d{1,3},\s?\d{1,3}\z/,
                               message: "must be RGB format like '51, 51, 51'" }

  # Milliseconds until this color's turn to display.
  def countdown_time
    ids = QueuedColor.order(:created_at).pluck(:id)
    position = ids.index(id)
    return BUFFER_MS if position.nil?  # unsaved or already dequeued

    duration_ms = (DURATION_TIME * 1000) + BUFFER_MS
    last_display = DisplayedColor.maximum(:created_at)
    elapsed_ms   = last_display ? ((Time.now - last_display) * 1000).to_i : 0
    time_until_next = [duration_ms - elapsed_ms, 0].max

    time_until_next + (position * duration_ms)
  end
end
