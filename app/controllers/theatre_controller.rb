class TheatreController < ApplicationController

  
  def foyer
    @stages = Stage.all
  end

  def performance
    @stage = Stage.find_by_slug!(params[:id])
    render :layout => false;
    @stage = Stage.includes(:messages).find_by_id(params[:id])
    @stage = Stage.includes(:stage_media).find_by_id(params[:id])
    @stage = Stage.includes(:avatar_stages).find_by_id(params[:id])
   
  end
  
  
  # broadcast the drawing 
  def show_drawing
    ActionCable.server.broadcast "drawing_channel#{params[:stage_id]}",
      fromx: params[:fromx],
      fromy: params[:fromy],
      tox: params[:tox],
      toy: params[:toy],
      colour: params[:colour],
      size: params[:size]
    head :ok
  end
  
  def audio_control
    ActionCable.server.broadcast "audio_channel#{params[:stage_id]}",
      audio_name: params[:audio_name],
      play_mode: params[:play_mode]
    head :ok
  end
  
end
