class DrawingChannel < ApplicationCable::Channel
  def subscribed
    stream_from "drawing_channel#{params[:stage]}"
  end
end