class MediaController < ApplicationController
  before_action :reject_anonymous
  def index
    if params[:term]
      med = Avatar.all + Sound.all + Backdrop.all
      @media = Array.new
      med.each do |m|
        if m.name.match(params[:term])
          @media << m
        else
          m.tags.each do |t|
            if t.name.match(params[:term])
              unless @media.include? m
                @media << m
              end
            end
          end
        end
      end
    else
      @media = Avatar.all + Sound.all + Backdrop.all
    end
    @media.sort_by { |m| m.name }
  end
end
