class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_channel_#{params['message']}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
  	p "=============#{data['room_id']}================"
  	Message.create!(content: data['message'])
  	room_id = data['room_id']
  	ActionCable.server.broadcast "room_channel_#{room_id}", message: data['message']
  end
end
