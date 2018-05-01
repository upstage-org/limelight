class MediaController < ApplicationController
  before_action :reject_anonymous
  def index
    @media = Array.new
    avatars = Avatar.all
    sounds = Sound.all
    backdrops = Backdrop.all

    if params[:uploader].present?
      avatars = avatars.where("uploader_id = ?", params[:uploader])
      backdrops = backdrops.where("uploader_id = ?", params[:uploader])
      sounds = sounds.where("uploader_id = ?", params[:uploader])
    end

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
      avatars = avatars.joins(:tags).where("tags.name LIKE ? OR avatars.name LIKE ?", "%#{params[:term]}%", "%#{params[:term]}%")
      sounds = sounds.joins(:tags).where("tags.name LIKE ? OR sounds.name LIKE ?", "%#{params[:term]}%", "%#{params[:term]}%")
      backdrops = backdrops.joins(:tags).where("tags.name LIKE ? OR backdrops.name LIKE ?", "%#{params[:term]}%", "%#{params[:term]}%")
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

    if params[:year].present?
      med = Array.new
      @media.each do |m|
        if m.created_at.year.to_s.match(params[:year])
          med << m
        end
      end
      @media = med
    end

    if params[:month].present?
      med = Array.new
      @media.each do |m|
        if m.created_at.month == Date::MONTHNAMES.index(params[:month])
          med << m
        end
      end
      @media = med
    end

    @media.sort_by { |m| m.name }
  end
end
