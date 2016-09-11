class TheatreController < ApplicationController
  def foyer
    @stages = Stage.all
  end
end
