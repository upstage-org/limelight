class AvatarStagesController < ApplicationController
  before_action :reject_anonymous
  def create
    if AvatarStage.create(params.require(:avatar_stage).permit([ :stage_id, :avatar_id ]))
      flash[:success] = "Avatar assigned"
    else
      flash[:danger] = "Something went wrong"
    end
    redirect_to Stage.find_by_id(params[:avatar_stage][:stage_id])
  end

  def destroy
    @record = AvatarStage.find_by_id(params[:id])
    if @record.destroy
      flash[:success] = "Avatar unassigned"
    else
      flash[:danger] = "Something went wrong"
    end
    redirect_to @record.stage
  end
end
