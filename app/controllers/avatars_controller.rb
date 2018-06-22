class AvatarsController < ApplicationController
  before_action :reject_anonymous
  before_action :set_avatar, :except => [ :index, :new, :create ]
  before_action :set_stage, :only => [ :update, :destroy ]

  def index
    @avatars = Avatar.all
  end

  def new
    @avatar = Avatar.new({ uploader: current_user })
  end

  def create
    @avatar = Avatar.new(avatar_params)
    @avatar.uploader = current_user
    if @avatar.save
      flash[:success] = "#{@avatar.name} created"
      redirect_to edit_avatar_path(@avatar)
    else
      flash.now[:danger] = 'Something went wrong'
      render :new
    end
  end

  def show
    redirect_to edit_avatar_path(@avatar)
  end

  def edit
    @avatar_dimensions = avatar_dimensions
    @avatar_url = avatar_url
  end

  def update
    if @stage.present?
      @stage.avatars << @avatar
      flash[:success] = "#{@avatar.name} assigned to #{@stage.name}"
      redirect_to request.referer
    else
      if @avatar.update(avatar_params)
        flash[:success] = "#{@avatar.name} updated"
        redirect_to edit_avatar_path(@avatar)
      else
        flash.now[:danger] = 'Something went wrong'
        render :edit
      end
    end
  end

  def destroy
    if @stage.present?
      @stage.avatars.delete(@avatar)
      flash[:success] = "#{@avatar.name} unassigned from #{@stage.name}"
      redirect_to request.referer
    else
      if @avatar.destroy
        flash[:success] = "#{@avatar.name} removed"
        redirect_to media_path
      else
        flash[:danger] = 'Something went wrong'
        redirect_to edit_avatar_path(@avatar)
      end
    end
  end

  private
    def set_avatar
      @avatar = Avatar.find_by_slug!(params[:slug])
    end

    def set_stage
      @stage = Stage.find_by_slug(params[:stage_slug]) if params[:stage_slug].present?
    end

    def avatar_params
      params.require(:avatar).permit([ :name, :source ])
    end

    def avatar_url
      return @avatar.source
    end

    def avatar_dimensions
      if @avatar.present?
        image = @avatar.source

        if image.present?
          geometry = Paperclip::Geometry.from_file(image)
          return [geometry.width.to_i, geometry.height.to_i]
        end
      end
    end
end
