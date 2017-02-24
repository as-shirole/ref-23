class Post
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated


  field :name, type: String
  field :content, type: String
  field :user_id, type: String
  
  #Associations
  belongs_to :user
  embeds_many :messages, cascade_callbacks: true
end
