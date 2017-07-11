class TheatreController < ApplicationController


  def foyer
    @stages = Stage.all
    @announcements = Announcement.order(:created_at).first(5)
  end

  def performance
    @stage = Stage.find_by_slug!(params[:id])
    render :layout => false;
    @message = Message.find_by_stage_id(params[:id])

    @user_list

  end


  # broadcast the drawing
  def show_drawing
    ActionCable.server.broadcast "drawing_channel#{params[:stage_id]}",
      drawing_option: params[:drawing_option],
      fromx: params[:fromx],
      fromy: params[:fromy],
      tox: params[:tox],
      toy: params[:toy],
      colour: params[:colour],
      size: params[:size]
    head :ok
  end



  def audio_control
    ActionCable.server.broadcast "audio_channel#{params[:stage_id]}",
      audio_name: params[:audio_name],
      audio_id: params[:audio_id],
      play_mode: params[:play_mode]
    head :ok
  end

end
