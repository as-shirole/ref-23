class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_channel_#{params['post_id']}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
  	post = Post.find(data['post_id'])
  	post.messages.create!(content: data['message'], by: data['user_id'])
  end
end
