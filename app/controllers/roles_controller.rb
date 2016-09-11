class RolesController < ApplicationController
  before_action :reject_anonymous

  before_action :set_role, :except => [ :index, :new, :create ]

  def index
    @roles = Role.all
  end

  def new
    @role = Role.new
  end

  def create
    @role = Role.new(role_params)
    if @role.save
      flash[:success] = "Role created"
      redirect_to @role
    else
      flash.now[:danger] = "Something went wrong"
      render :new
    end
  end

  def edit
  end

  def update
    if @role.update(role_params)
      flash[:success] = "Role updated"
      redirect_to @role
    else
      flash.now[:danger] = "Something went wrong"
      render :edit
    end
  end

  def destroy
    if @role.destroy
      flash[:success] = "Role removed"
      redirect_to users_path
    else
      flash[:dnager] = "Something went wrong"
      redirect_to @role
    end
  end

  private
    def role_params
      params.require(:role).permit(:name)
    end

    def set_role
      @role = Role.find_by_slug(params[:id])
    end
end
