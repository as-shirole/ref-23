class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(chat_room_id, message_id)
  	chat_room = ChatRoom.find(chat_room_id)
  	message = chat_room.messages.find(message_id)
    ActionCable.server.broadcast "room_channel_#{chat_room.id.to_s}", message: render_message(message)
  end

  private
	  def render_message(message)
	  	ApplicationController.renderer.render(partial: "messages/message", locals: {message: message})
	  end 
end
