class MediaController < ApplicationController
  before_action :reject_anonymous
  def index
    @media = Array.new
    @avatars = Avatar.all
    @sounds = Sound.all
    @backdrops = Backdrop.all

    search(params[:term]) if params[:term].present?
    filter_by_uploader(params[:uploader]) if params[:uploader].present?
    filter_by_stage(params[:stage]) if params[:stage].present?
    filter_by_tag(params[:tag]) if params[:tag].present?
    filter_by_year(params[:year]) if params[:year].present?
    filter_by_month(params[:month]) if params[:month].present?

    if params[:type].present?
      case params[:type]
      when "Avatar"
        @media = @avatars
      when "Backdrop"
        @media = @backdrops
      when "Sound"
        @media = @sounds
      end
    else
      @media = @avatars + @sounds + @backdrops
    end

    @media.sort_by { |m| m.name }
  end

  private
    def filter_by_stage(stage)
      @avatars = @avatars.joins(:stages).where(stages: { id: stage })
      @sounds = @sounds.joins(:stages).where(stages: { id: stage })
      @backdrops = @backdrops.joins(:stages).where(stages: { id: stage })
    end

    def filter_by_year(year)
      @avatars = @avatars.by_year(year)
      @backdrops = @backdrops.by_year(year)
      @sounds = @sounds.by_year(year)
    end

    def filter_by_month(month)
      @avatars = @avatars.by_month(month)
      @backdrops = @backdrops.by_month(month)
      @sounds = @sounds.by_month(month)
    end

    def filter_by_uploader(uploader)
      @avatars = @avatars.where("uploader_id = ?", uploader)
      @backdrops = @backdrops.where("uploader_id = ?", uploader)
      @sounds = @sounds.where("uploader_id = ?", uploader)
    end

    def filter_by_tag(tag)
      @avatars = @avatars.joins(:tags).where(tags: { id: tag })
      @sounds = @sounds.joins(:tags).where(tags: { id: tag })
      @backdrops = @backdrops.joins(:tags).where(tags: { id: tag })
    end

    def search(term)
      @avatars = @avatars.joins(:tags).where("tags.name LIKE ? OR avatars.name LIKE ?", "%#{term}%", "%#{term}%")
      @sounds = @sounds.joins(:tags).where("tags.name LIKE ? OR sounds.name LIKE ?", "%#{term}%", "%#{term}%")
      @backdrops = @backdrops.joins(:tags).where("tags.name LIKE ? OR backdrops.name LIKE ?", "%#{term}%", "%#{term}%")
    end
end
