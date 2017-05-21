class HomeController < ApplicationController
  def index
    @videos_list = VideolistProcess.where(hidden: false)
  end
  def chat
    @chats = Chat.order('id desc').last(100)
  end
  def chat_save
    if params[:name] && params[:chat_data]
      chat = Chat.new(name: params[:name], chat_data: params[:chat_data])
      chat.save
    end
    redirect_to :chat
  end
end