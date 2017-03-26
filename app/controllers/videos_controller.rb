class VideosController < ApplicationController
  def display
    @video = VideolistProcess.find_by(id: params[:id])
  end
  def hidden_inn
    @videos_list = VideolistProcess.where(hidden: true)
  end
end