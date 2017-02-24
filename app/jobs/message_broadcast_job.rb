class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(post_id, message_id)
  	post = Post.find(post_id)
  	message = post.messages.find(message_id)
    ActionCable.server.broadcast "room_channel_#{post.id.to_s}", message: render_message(message)
  end

  private
	  def render_message(message)
	  	ApplicationController.renderer.render(partial: "messages/message", locals: {message: message})
	  end 
end
