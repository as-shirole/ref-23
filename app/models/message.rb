class Message
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated

  field :content, type: String
  field :by , type: String


  embedded_in :post
  belongs_to :user, foreign_key: :by
  after_create {MessageBroadcastJob.perform_later self.post.id.to_s, self.id.to_s}
end
