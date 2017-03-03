class WebNotificationChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from "web_notifications_#{current_user.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive
  	ActionCable.server.broadcast "web_notifications_#{current_user.id}", { title: 'New things!', body: 'All the news that is fit to print' }
  end
end
