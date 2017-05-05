class TagsController < ApplicationController
  before_action :reject_anonymous
  before_action :set_perspective
  before_action :set_tag, :except => [ :index, :create, :new ]

  def index
    if @perspective.present?
      @tags = @perspective.tags
    else
      @tags = Tag.all
    end
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.find_by_name(params[:tag][:name])
    @tag = Tag.new(tag_params) unless @tag.present?
    if @tag.new_record?
      if @tag.save
        flash[:success] = 'Tag created.'
      else
        flash.now[:danger] = 'Failed to create tag'
        render :new
      end
    end
    if @perspective.present?
      unless @perspective.tags.exists?(@tag.id)
        if @perspective.tags << @tag
          flash[:success] = "#{@tag.name} assigned to #{@perspective.name}"
        else
          flash.now[:danger] = "Failed to assign #{@tag.name} to #{@perspective.name}"
        end
      end
      redirect_to @perspective
    else
      redirect_to @tag
    end
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
        flash[:success] = 'Tag removed.'
        redirect_to tags_path
      else
        flash.now[:danger] = 'Something went wrong'
        redirect_to @tag
      end
    end
  end

  private
    def set_tag
      @tag = Tag.find_by_name!(params[:name])
    end

    def tag_params
      params.require(:tag).permit([:name])
    end

    def set_perspective
      if params[:avatar_id].present?
        @perspective = Avatar.find_by_slug!(params[:avatar_id])
        @create_path = new_avatar_tag_path(@perspective)
      elsif params[:stage_id].present?
        @perspective = Stage.find_by_slug!(params[:stage_id])
        @create_path = new_stage_tag_path(@perspective)
      else
        @create_path = new_tag_path
      end
    end
end
