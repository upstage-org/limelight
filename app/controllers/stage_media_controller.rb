class StageMediaController < ApplicationController
  def create
    if StageMedium.create(params.permit([ :stage_id, :medium_id ]))
      flash[:success] = "Media assigned"
    else
      flash[:danger] = "Something went wrong"
    end
    redirect_to Stage.find_by_id(params[:stage_id])
  end

  def destroy
    @record = StageMedium.find_by_id(params[:id])
    if @record.destroy
      flash[:success] = "Media unassigned"
    else
      flash[:danger] = "Something went wrong"
    end
    redirect_to @record.stage
  end
end
