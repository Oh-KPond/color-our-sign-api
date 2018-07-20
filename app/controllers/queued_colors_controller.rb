class QueuedColorsController < ApplicationController

  def index
    colors = QueuedColor.all
    render json: colors.as_json, status: :ok
  end

  def color
    if QueuedColor.first == nil
      no_queued_color = DisplayedColor.last
      render json: no_queued_color.as_json, status: :ok
    else
      color_num = {
        id: QueuedColor.first.id,
        color: QueuedColor.first.color_number
      }
      render json: color_num.as_json, status: :ok
    end
  end

  def create
    color = QueuedColor.new(color_params)
    if color.save
      if QueuedColor.count == 1
        QueuedColor.color_change
      end
      render json: {id: color.id, countdown: color.countdown_time}, status: :ok
    else
      render json: {ok: false, errors: color.errors}, status: :bad_request
    end
  end
end

private

def color_params
  return params.permit(:color)
end
