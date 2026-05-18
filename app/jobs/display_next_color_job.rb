class DisplayNextColorJob < ApplicationJob
  queue_as :default

  def perform
    next_color = QueuedColor.first
    return if next_color.nil?

    QueuedColor.transaction do
      DisplayedColor.create!(color: next_color.color)
      next_color.destroy!
    end

    if QueuedColor.any?
      self.class.set(wait: QueuedColor::DURATION_TIME.seconds).perform_later
    end
  end
end
