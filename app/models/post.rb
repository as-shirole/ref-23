class Post
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated


  field :name, type: String
  field :content, type: String
  
  #Associations
  embedded_in :user
end
