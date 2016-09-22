class TheatreController < ApplicationController

  
  def foyer
    @stages = Stage.all
  end

  def performance
    @stage = Stage.find_by_slug!(params[:id])
    render :layout => true;
    @stage = Stage.includes(:messages).find_by(id: params[:id])
  end
  
  
  # Messages displayed when a user enters a chat room
  def show
  end
  
  
  
end
