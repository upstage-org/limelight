class StagesController < ApplicationController
  before_action :reject_anonymous
  before_action :set_stage, :except => [ :index, :new, :create ]

  def index
    @stages = Stage.all
  end

  def new
    @stage = Stage.new({ owner: current_user })
  end

  def create
    @stage = Stage.new(stage_params)
    @stage.owner = current_user
    if @stage.save
      flash[:success] = "Stage created"
      redirect_to @stage
    else
      flash.now[:danger] = "Something went wrong"
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @stage.update(stage_params)
      flash[:success] = "Stage updated"
      redirect_to @stage
    else
      flash.now[:danger] = "Something went wrong"
      render :edit
    end
  end

  def destroy
    if @stage.destroy
      flash[:success] = "Stage removed"
      redirect_to stages_path
    else
      flash[:danger] = "Something went wrong"
      redirect_to @stage
    end
  end

  def clone
    @new_stage = @stage.dup
    @new_stage.name = params[:name] || "#{@new_stage.name} (clone)"
    @new_stage.owner = current_user

    if params[:include_tags]
      @stage.tags.each do |t|
        @new_stage.tags << t
      end
    end

    if params[:include_avatars]
      @stage.avatars.each do |a|
        @new_stage.avatars << a
      end
    end

    if @new_stage.save
      flash[:success] = "#{@stage.name} cloned successfully"
      redirect_to @new_stage
    else
      flash[:danger] = "Something went wrong"
      redirect_to @stage
    end
  end

  private
    def set_stage
      @stage = Stage.find_by_slug!(params[:id] || params[:stage_id])
    end

    def stage_params
      params.require(:stage).permit([ :name ])
    end
end
