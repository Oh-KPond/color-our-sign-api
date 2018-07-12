class QueuedColor < ApplicationRecord
  validates :color, presence: true
  validates :color, length: { in: 7..9 }
  
end
