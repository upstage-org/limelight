class SoundsController < ApplicationController
  before_action :reject_anonymous
  before_action :set_sound, :except => [ :index, :new, :create ]

  def index
    @sounds = Sound.all
  end

  def new
    @sound = Sound.new
  end

  def create
    @sound = Sound.new(sound_params)
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

  def edit
  end

  def update
    if @sound.update(sound_params)
      flash[:success] = "#{@sound.name} updated"
      redirect_to edit_sound_path(@sound)
    else
      flash.now[:danger] = 'Something went wrong'
      render :edit
    end
  end

  def destroy
    if @sound.destroy
      flash[:success] = "#{@sound.name} removed"
      redirect_to sounds_path
    else
      flash[:danger] = 'Something went wrong'
      redirect_to edit_sound_path(@sound)
    end
  end

  private
    def set_sound
      @sound = Sound.find_by_slug!(params[:slug])
    end

    def sound_params
      params.require(:sound).permit([ :name, :source ])
    end
end
