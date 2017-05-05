class AvatarsController < ApplicationController
  before_action :reject_anonymous
  before_action :set_avatar, :only => [ :show, :edit, :update, :destroy ]

  def index
    @avatars = Avatar.all
  end

  def new
    @avatar = Avatar.new({ medium: Medium.new })
  end

  def create
    @avatar = Avatar.new(avatar_params)
    @avatar.medium.name = @avatar.name
    @avatar.medium.media_type = 'Image'
    @avatar.medium.owner = current_user
    if @avatar.save
      flash[:success] = 'Avatar created.'
      redirect_to @avatar
    else
      flash.now[:danger] = 'Something went wrong'
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @avatar.update(avatar_params)
      flash[:success] = 'Avatar updated'
      redirect_to @avatar
    else
      flash.now[:danger] = 'Something went wrong'
      render :edit
    end
  end

  def destroy
    if @avatar.destroy
      flash[:success] = 'Avatar removed'
      redirect_to avatars_path
    else
      flash[:danger] = 'Something went wrong'
      redirect_to @avatar
    end
  end

  private
    def set_avatar
      @avatar = Avatar.find_by_slug!(params[:id])
    end

    def avatar_params
      params.require(:avatar).permit([ :name, :medium_attributes => [ :id, :file ] ])
    end
end
