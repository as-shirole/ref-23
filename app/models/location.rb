class Location
  include Mongoid::Document
  
  field :coordinates, :type => Array
  field :address, type: String
	field :default, type: Boolean
  
  embedded_in :user
	
	after_save :update_coordinates
	def update_coordinates
	    self.address = Geocoder.search(self.coordinates).first.address
	end 

end