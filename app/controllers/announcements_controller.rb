class AnnouncementsController < ApplicationController
  before_action :reject_anonymous, :except => [ :index, :show ]
  before_action :set_announcement, :except => [ :index, :new, :create ]

  def index
    @announcements = Announcement.all.order(:created_at)
  end

  def new
    @announcement = Announcement.new(:author => current_user)
  end

  def create
    @announcement = Announcement.new(annnouncement_params)
    @announcement.author = current_user
    if @announcement.save
      flash[:success] = "Announcement created"
      redirect_to edit_announcement_path(@announcement)
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
    if @announcement.update(annnouncement_params)
      flash[:success] = "Announcement updated"
      redirect_to edit_announcement_path(@announcement)
    else
      flash.now[:danger] = "Something went wrong"
      render :edit
    end
  end

  def destroy
    if @announcement.destroy
      flash[:success] = "Announcement removed"
      redirect_to announcements_path
    else
      flash[:danger] = "Something went wrong"
      redirect_to edit_announcement_path(@announcement)
    end
  end

  private
    def set_announcement
      @announcement = Announcement.find_by_slug!(params[:slug])
    end

    def annnouncement_params
      params.require(:announcement).permit([ :title, :subtitle, :body ])
    end
end
