class QueuedColor < ApplicationRecord
  require 'rufus-scheduler'
  validates :color, presence: true
  # validates :color, length: { in: 7..10 }
  # TODO: Readd length validation when input length is known

  def self.countdown
    count = QueuedColor.count

    scheduler = Rufus::Scheduler.new

    if count > 0

      scheduler.every '30s' do
        Rails.logger.info "time flies, it's now #{Time.now}"
        QueuedColor.first.destroy

        if QueuedColor.first == nil
          scheduler.shutdown
        end
      end
    end
  end

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
