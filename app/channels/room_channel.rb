class RoomChannel < ApplicationCable::Channel
  def subscribed
    p "===============#{current_user.inspect}==================="
    stream_from "room_channel_#{params['chat_room_id']}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
  	chat_room = ChatRoom.find(data['chat_room_id'])
  	chat_room.messages.create!(content: data['message'], by: data['user_id'])
  end

  def away

  end
  
end
