class MediaController < ApplicationController
  before_action :reject_anonymous

  before_action :set_medium, :except => [ :index, :new, :create ]

  def index
    @media = Medium.all
  end

  def show
  end

  def new
    @medium = Medium.new({ :owner => current_user })
  end

  def create
    @medium = Medium.new(medium_params)
    @medium.owner = current_user
    if @medium.save
      flash[:success] = "Medium created"
      redirect_to @medium
    else
      flash.now[:danger] = "Something went wrong"
      render :new
    end
  end

  def edit
  end

  def update
    if @medium.update(medium_params)
      flash[:success] = "Medium updated"
      redirect_to @medium
    else
      flash.now[:danger] = "Something went wrong"
      render :edit
    end
  end

  def destroy
    if @medium.destroy
      flash[:success] = "Medium removed"
      redirect_to media_path
    else
      flash[:danger] = "Something went wrong"
      render @medium
    end
  end

  private
    def set_medium
      @medium = Medium.find_by_slug!(params[:id])
    end

    def medium_params
      params.require(:medium).permit([ :name, :file, :media_type ])
    end
end
