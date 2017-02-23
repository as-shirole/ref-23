class Message
  include Mongoid::Document
  field :content, type: String



  # after_create {MessageBroadcastJob.perform_later self.id.to_s}
end
