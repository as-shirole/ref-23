class ChatRoom
  include Mongoid::Document
  field :name, type: String
  field :desc, type: String
  embeds_many :messages, cascade_callbacks: true
end
