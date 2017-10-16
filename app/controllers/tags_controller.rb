class TagsController < ApplicationController
  before_action :reject_anonymous
  before_action :set_perspective, :except => [ :show ]
  before_action :set_tag, :only => [ :show, :destroy ]

  def index
    if @perspective.present?
      @tags = @perspective.tags
    else
      @tags = Tag.all
    end
  end

  def create
    @tag = Tag.new tag_params
    @tag = Tag.find_by_name(@tag.name) if Tag.exists?(name: @tag.name)
    if @tag.new_record?
      if @tag.save
        flash[:success] = "Tag \'#{@tag.name}\' created"
      else
        flash[:danger] = @tag.errors.full_messages.to_sentence
        return redirect_to @perspective
      end
    end
    unless @perspective.tags.exists?(@tag.id)
      @perspective.tags << @tag
      flash[:success] = "Assigned #{@tag.name} to #{@perspective.name}"
    end
    redirect_to @perspective
  end

  def show
  end

  def destroy
    if @perspective.present?
      if @perspective.tags.delete(@tag)
        flash[:success] = "Unassigned #{@tag.name} from #{@perspective.name}"
      else
        flash.now[:danger] = 'Something went wrong'
      end
      redirect_to @perspective
    else
      if @tag.destroy
        flash[:success] = "Tag #{@tag.name} removed"
        redirect_to tags_path
      else
        flash.now[:danger] = 'Something went wrong'
        redirect_to @tag
      end
    end
  end

  private
    def tag_params
      params.require(:tag).permit([:name])
    end

    def set_tag
      @tag = Tag.find_by_name!(params[:name])
    end

    def set_perspective
      if params[:avatar_slug].present?
        @perspective = Avatar.find_by_slug!(params[:avatar_slug])
      elsif params[:stage_slug].present?
        @perspective = Stage.find_by_slug!(params[:stage_slug])
      elsif params[:sound_slug].present?
        @perspective = Sound.find_by_slug!(params[:sound_slug])
      elsif params[:backdrop_slug].present?
        @perspective = Backdrop.find_by_slug!(params[:backdrop_slug])
      end
    end
end
