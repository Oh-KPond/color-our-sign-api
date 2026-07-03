class QueuedColorsController < ApplicationController
  rate_limit to: 10, within: 1.minute, only: :create, with: -> {
    render json: { ok: false, error: "Too many requests. Please slow down." },
           status: :too_many_requests
  }

  def index
    colors = QueuedColor.all
    render json: colors.as_json, status: :ok
  end

  def color
    next_color = QueuedColor.first
    if next_color
      render json: { id: next_color.id, color: next_color.color }, status: :ok
    else
      last_displayed = DisplayedColor.last
      if last_displayed
        render json: last_displayed.as_json, status: :ok
      else
        render json: nil, status: :not_found
      end
    end
  end

  def create
    if QueuedColor.count >= QueuedColor::MAX_QUEUE_SIZE
      render json: { ok: false, error: "Queue is full, please try again in a moment." },
             status: :service_unavailable
      return
    end

    color = QueuedColor.new(color_params)
    if color.save
      schedule_next_display_if_needed
      render json: { id: color.id, countdown: color.countdown_time }, status: :ok
    else
      render json: { ok: false, errors: color.errors }, status: :bad_request
    end
  end

  private

  def schedule_next_display_if_needed
    return if SolidQueue::Job.where(class_name: "DisplayNextColorJob", finished_at: nil).any?
    DisplayNextColorJob.set(wait: QueuedColor::DURATION_TIME.seconds).perform_later
  end

  def color_params
    params.permit(:color)
  end
end
