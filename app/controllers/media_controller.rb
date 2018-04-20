class MediaController < ApplicationController
  before_action :reject_anonymous
  def index
    @media = Array.new
    avatars = Avatar.all
    sounds = Sound.all
    backdrops = Backdrop.all
    others = Array.new

    if params[:stage].present?
      avatars = avatars.joins(:stages).where(stages: { id: params[:stage] })
      sounds = sounds.joins(:stages).where(stages: { id: params[:stage] })
      backdrops = backdrops.joins(:stages).where(stages: { id: params[:stage] })
    end

    if params[:tag].present?
      avatars = avatars.joins(:tags).where(tags: { id: params[:tag] })
      sounds = sounds.joins(:tags).where(tags: { id: params[:tag] })
      backdrops = backdrops.joins(:tags).where(tags: { id: params[:tag] })
    end

    if params[:term].present?
      avt = avatars.where("avatars.name NOT LIKE ?", "%#{params[:term]}%")
      s = sounds.where("sounds.name NOT LIKE ?", "%#{params[:term]}%")
      bd = backdrops.where("backdrops.name NOT LIKE ?", "%#{params[:term]}%")

      avatars = avatars.where("avatars.name LIKE ?", "%#{params[:term]}%")
      sounds = sounds.where("sounds.name like ?", "%#{params[:term]}%")
      backdrops = backdrops.where("backdrops.name like ?", "%#{params[:term]}%")

      if params[:type].present?
        case params[:type]
        when "Avatar"
          med = avt
        when "Backdrop"
          med = bd
        when "Sound"
          med = s
        end
      else        
        med = avt + s + bd
      end
      med.each do |m|
          m.tags.each do |t|
            if t.name.match(params[:term])
              unless others.include? m
                others << m
              end
            end
          end
      end
    end

    if params[:type].present?
      case params[:type]
      when "Avatar"
        @media = avatars
      when "Backdrop"
        @media = backdrops
      when "Sound"
        @media = sounds
      end
    else
      @media = avatars + sounds + backdrops
    end
    @media += others
    @media.sort_by { |m| m.name }
  end
end
