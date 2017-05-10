class MediaController < ApplicationController
  def index
    @media = Avatar.all + Sound.all
    @media.sort_by { |m| m.name }
  end
end
