class MediaController < ApplicationController
  before_action :reject_anonymous
  def index
    @media = Avatar.all + Sound.all
    @media.sort_by { |m| m.name }
  end
end
