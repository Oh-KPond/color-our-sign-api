class QueuedColor < ApplicationRecord
  validates :color, presence: true
  # validates :color, length: { in: 7..10 }
  # TODO: Readd length validation when input length is known

  def countdown_time # default interval time 30 seconds = 30000 (07/16/18)
    count = QueuedColor.count
    if count > 2
      time = (count - 2) * 30000
      return time
    else
      return 0
    end
  end
end
