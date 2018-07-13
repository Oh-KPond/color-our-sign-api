class QueuedColorsController < ApplicationController

  def index
    color = QueuedColor.all
    render json: color.as_json, status: :ok
  end

  def color
    color = QueuedColor.first.color
    render json: color.as_json, status: :ok
  end

end
