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

  def destroy
      if @tag.destroy
        flash[:success] = 'Tag removed.'
        redirect_to tags_path
      else
        flash.now[:danger] = 'Something went wrong'
        redirect_to @tag
      end
  end

  private
    def set_tag
      @tag = Tag.find_by_name!(params[:name])
    end

    def tag_params
      params.require(:tag).permit([ :name ])
    end
end
