class TheatreController < ApplicationController
  def foyer
    @stages = Stage.all
  end

  def performance
    @stage = Stage.find_by_slug!(params[:id])
    render :layout => false
  end
end
