class QueuedColor < ApplicationRecord
  validates :color, presence: true
  # validates :color, length: { in: 7..10 }
  # TODO: Readd length validation when input length is known

  def countdown_time
    return 100000
  end
end
