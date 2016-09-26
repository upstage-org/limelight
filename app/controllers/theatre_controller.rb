class TheatreController < ApplicationController

  
  def foyer
    @stages = Stage.all
  end

  def performance
    @stage = Stage.find_by_slug!(params[:id])
    render :layout => true;
    @stage = Stage.includes(:messages).find_by(id: params[:id])
   
    
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
  
  
  
end
