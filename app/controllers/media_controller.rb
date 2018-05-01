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

    if params[:year].present?
      if Rails.env.production?
        avatars = Avatar.where('extract(year from avatars.created_at) = ?', params[:year])
        backdrops = Backdrop.where('extract(year from backdrops.created_at) = ?', params[:year])
        sounds = Sound.where('extract(year from sounds.created_at) = ?', params[:year])
      else
        avatars = Avatar.where("cast(strftime('%Y', avatars.created_at) as int) = ?", params[:year])
        backdrops = Backdrop.where("cast(strftime('%Y', backdrops.created_at) as int) = ?", params[:year])
        sounds = Sound.where("cast(strftime('%Y', sounds.created_at) as int) = ?", params[:year])
      end
    end

    if params[:month].present?
      if Rails.env.production?
        avatars = Avatar.where('extract(month from avatars.created_at) = ?', params[:month])
        backdrops = Backdrop.where('extract(month from backdrops.created_at) = ?', params[:month])
        sounds = Sound.where('extract(month from sounds.created_at) = ?', params[:month])
      else
        avatars = Avatar.where("cast(strftime('%m', avatars.created_at) as int) = ?", params[:month])
        backdrops = Backdrop.where("cast(strftime('%m', backdrops.created_at) as int) = ?", params[:month])
        sounds = Sound.where("cast(strftime('%m', sounds.created_at) as int) = ?", params[:month])
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

    @media.sort_by { |m| m.name }
  end
end
