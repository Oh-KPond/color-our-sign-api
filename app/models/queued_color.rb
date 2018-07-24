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
          displayed_color = DisplayedColor.new(color: QueuedColor.first.color_number)
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

  # def color_number
  #   case QueuedColor.first.color
  #   when '{"r":255,"g":0,"b":0,"a":1}' # '#ff0000'
  #     return 1
  #   when '{"r":255,"g":165,"b":0,"a":1}' # '#ffa500'
  #     return 2
  #   when '{"r":255,"g":255,"b":0,"a":1}' # '#ffff00'
  #     return 3
  #   when '{"r":0,"g":255,"b":0,"a":1}' # '#00ff00'
  #     return 4
  #   when '{"r":0,"g":0,"b":255,"a":1}' # '#0000ff'
  #     return 5
  #   when '{"r":85,"g":26,"b":139,"a":1}' # '#551a8b'
  #     return 6
  #   when '{"r":3,"g":169,"b":244,"a":1}' # '#03a9f4'
  #     return 7
  #   when '{"r":233,"g":30,"b":99,"a":1}' # '#e91e63'
  #     return 8
  #   when '{"r":0,"g":150,"b":136,"a":1}' #'#009688'
  #     return 9
  #   when '{"r":128,"g":0,"b":0,"a":1}' # '#800000'
  #     return 10
  #   when '{"r":255,"g":0,"b":255,"a":1}' # '#ff00ff'
  #     return 11
  #   when '{"r":0,"g":102,"b":0,"a":1}' # '#006600'
  #     return 12
  #   when '{"r":0,"g":0,"b":0}' # rainbow colors
  #     return 13
  #   else
  #     return 0
  #   end
  #
  # end
end
