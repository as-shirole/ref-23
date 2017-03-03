class UserChatRoom
  include Mongoid::Document
  field :user_id, type: String
  field :chat_room_id, type: String
end
