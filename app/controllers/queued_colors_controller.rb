class QueuedColorsController < ApplicationController

  def index
    color = QueuedColor.first
    render json: color.as_json, status: :ok
  end

end
