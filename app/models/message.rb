class Message
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated

  field :content, type: String
  field :by , type: String


  embedded_in :chat_room
  belongs_to :user, foreign_key: :by
  after_create {MessageBroadcastJob.perform_later self.chat_room.id.to_s, self.id.to_s}


  def is_my_msg(user)
  	if user.id == self.by
  		"right"
  	else
  		"left"
  	end

  end
end
