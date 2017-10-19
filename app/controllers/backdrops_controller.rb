class BackdropsController < ApplicationController
  before_action :reject_anonymous
  before_action :set_backdrop, :except => [ :index, :new, :create ]
  before_action :set_stage, :only => [ :update, :destroy ]

  def index
    @backdrops = Backdrop.all
  end

  def new
    @backdrop = Backdrop.new
  end

  def create
    @backdrop = Backdrop.new(backdrop_params)
    if @backdrop.save
      flash[:success] = "#{@backdrop.name} created"
      redirect_to edit_backdrop_path(@backdrop)
    else
      flash.now[:danger] = 'Something went wrong'
      render :new
    end

  end

  def show
    redirect_to edit_backdrop_path(@backdrop)
  end

  def edit
  end

  def update
    if @stage.present?
      @stage.backdrops << @backdrop
      flash[:success] = "#{@backdrop.name} assigned to #{@stage.name}"
      redirect_to @stage
      #if "Check view"
      #  redirect_to edit_backdrop_path(@backdrop)
      #else
      #  redirect_to @stage
      #end
    else
      if @backdrop.update(backdrop_params)
        flash[:success] = "#{@backdrop.name} updated"
        redirect_to edit_backdrop_path(@backdrop)
      else
        flash.now[:danger] = 'Something went wrong'
        render :edit
      end
    end
  end

  def destroy
    if @stage.present?
      @stage.backdrops.delete(@backdrop)
      flash[:success] = "#{@backdrop.name} unassigned from #{@stage.name}"
      redirect_to @stage
    else
      if @backdrop.destroy
        flash[:success] = "#{@backdrop.name} removed"
        redirect_to media_path
      else
        flash[:danger] = 'Something went wrong'
        redirect_to edit_backdrop_path(@backdrop)
      end
    end
  end

  private
    def set_backdrop
      @backdrop = Backdrop.find_by_slug!(params[:slug])
    end

    def set_stage
      @stage = Stage.find_by_slug(params[:stage_slug]) if params[:stage_slug].present?
    end

    def backdrop_params
      params.require(:backdrop).permit([ :name, :source ])
    end
end
