class QueuedColor < ApplicationRecord
  require 'date'
  require 'rufus-scheduler'
  validates :color, presence: true
  # validates :color, length: { in: 7..10 }
  # TODO: Read length validation when input length is known

  # default interval time 10 seconds = 10000 (07/20/18)
  DURATION_TIME = 10

  def self.color_change
    count = QueuedColor.count

    ActiveRecord::Base.connection_pool.with_connection do
    scheduler = Rufus::Scheduler.new

      if count > 0
        @@job = scheduler.schedule_every("#{DURATION_TIME.to_s}s",  :allow_overlapping => false) do
          displayed_color = DisplayedColor.new(color: QueuedColor.first.color)
          displayed_color.save

          QueuedColor.first.destroy

          if QueuedColor.first == nil
            scheduler.shutdown
            ActiveRecord::Base.connection_pool.release_connection
          end
        end
      end
    end
  end


  def countdown_time
    count = QueuedColor.count
    duration_seconds = ((DURATION_TIME * 1000) + 2000)

    # calulates remaining time if there is any
    if @@job.last_time == nil
      remaining_time = duration_seconds - ((Time.now.to_i - QueuedColor.first.created_at.to_i) * 1000)
    else
      remaining_time = duration_seconds - ((Time.now.to_i - @@job.last_time.seconds) * 1000)
    end

    # calculates the countdown time
    if count == 2
      return remaining_time.round
    elsif count > 2
      time = (count - 2) * duration_seconds
      total_remaining_time = time + remaining_time
      return total_remaining_time.round
    else
      return 2000
    end
  end

end
