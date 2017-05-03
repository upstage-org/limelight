class TagsController < ApplicationController
  before_action :reject_anonymous
  before_action :set_tag, :except => [ :index, :create, :new ]

  def index
    @tags = Tag.all
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      flash[:success] = 'Tag created.'
      redirect_to @tag
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
    if @tag.update(tag_params)
      flash[:success] = 'Tag updated.'
      redirect_to @tag
    else
      flash.now[:danger] = 'Something went wrong'
      render :edit
    end
  end

  def destroy
      if @tag.destroy
        flash[:success] = 'Tag removed.'
      else
        flash.now[:danger] = 'Something went wrong'

      end
  end

  private
    def set_tag
      @tag = Tag.find_by_slug!(params[:id])
    end

    def tag_params
      params.require(:tag).permit([ :name ])
    end
end
