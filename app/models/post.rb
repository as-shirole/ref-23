class Post
  include Mongoid::Document

  field :name, type: String
  field :content, type: String

  #Associations
  embedded_in :user
end
