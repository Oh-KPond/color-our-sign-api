class DisplayedColorsController < ApplicationController
  def index
    colors = DisplayedColor.order(created_at: :desc).limit(100)
    render json: colors.as_json, status: :ok
  end
end
