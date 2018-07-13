class QueuedColorsController < ApplicationController

  def index
    color = QueuedColor.all
    render json: color.as_json, status: :ok
  end

  def color
    if QueuedColor.first == nil
      no_color = QueuedColor.first
      render json: no_color.as_json, status: :ok
    else
      color = QueuedColor.first.color
      render json: color.as_json, status: :ok
    end
  end

end
