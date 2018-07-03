class SoundsController < ApplicationController
  before_action :reject_anonymous
  before_action :set_sound, :except => [ :index, :new, :create ]
  before_action :set_stage, :only => [ :update, :destroy ]

  def index
    @sounds = Sound.all
  end

  def new
    @sound = Sound.new({ uploader: current_user })
  end

  def create
    @sound = Sound.new(sound_params)
    @sound.uploader = current_user
    if @sound.save
      flash[:success] = "#{@sound.name} created"
      redirect_to edit_sound_path(@sound)
    else
      flash.now[:danger] = 'Something went wrong'
      render :new
    end
  end

  def show
    redirect_to edit_sound_path(@sound)
  end

  def update
    if @stage.present?
      @stage.sounds << @sound
      flash[:success] = "#{@sound.name} assigned to #{@stage.name}"
      redirect_to request.referer
    else
      if @sound.update(sound_params)
        flash[:success] = "#{@sound.name} updated"
        redirect_to edit_sound_path(@sound)
      else
        flash.now[:danger] = 'Something went wrong'
        render :edit
      end
    end
  end

  def destroy
    if @stage.present?
      @stage.sounds.delete(@sound)
      flash[:success] = "#{@sound.name} unassigned from #{@stage.name}"
      redirect_to request.referer
    else
      if @sound.destroy
        flash[:success] = "#{@sound.name} removed"
        redirect_to media_path
      else
        flash[:danger] = 'Something went wrong'
        redirect_to edit_sound_path(@sound)
      end
    end
  end

  private
    def set_sound
      @sound = Sound.find_by_slug!(params[:slug])
    end

    def set_stage
      @stage = Stage.find_by_slug(params[:stage_slug]) if params[:stage_slug].present?
    end

    def sound_params
      params.require(:sound).permit([ :name, :source ])
    end
end
