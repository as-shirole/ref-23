class Location
  include Mongoid::Document
  
  field :coordinates, :type => Array
  field :address, type: String
	field :default, type: Boolean
  
  embedded_in :user
	
  def self.types
  	["accounting","airport","amusement_park","aquarium","art_gallery","atm","bakery","bank","bar",
  	 "beauty_salon","bicycle_store","book_store","bowling_alley","bus_station","cafe",
  	 "campground","car_dealer","car_rental","car_repair","car_wash","casino","cemetery",
  	 "church","city_hall","clothing_store","convenience_store","courthouse","dentist","department_store",
  	 "doctor","electrician","electronics_store","embassy","establishment (deprecated)","finance (deprecated)",
  	 "fire_station","florist","food (deprecated)","funeral_home","furniture_store","gas_station",
  	 "general_contractor (deprecated)","grocery_or_supermarket(deprecated)","gym","hair_care","hardware_store",
  	 "health (deprecated)","hindu_temple","home_goods_store","hospital","insurance_agency",
  	 "jewelry_store","laundry","lawyer","library","liquor_store","local_government_office",
  	 "locksmith","lodging","meal_delivery","meal_takeaway","mosque","movie_rental","movie_theater",
  	 "moving_company","museum","night_club","painter","park","parking","pet_store","pharmacy","physiotherapist",
  	 "place_of_worship (deprecated)","plumber","police","post_office","real_estate_agency","restaurant",
  	 "roofing_contractor","rv_park","school","shoe_store","shopping_mall","spa","stadium","storage","store",
  	 "subway_station","synagogue","taxi_stand","train_station","transit_station","travel_agency","university",
  	 "veterinary_care","zoo"]
  end

  after_create :check_default_location
	after_save :update_coordinates
	def update_coordinates
	    self.address = Geocoder.search(self.coordinates).first.address
	end 

	def to_coordinates
		self.coordinates.reverse
	end

	def to_lat_long
		return self.coordinates.join(',')
	end

	def check_default_location
		return true if self.user.nil?
		defaults = self.user.locations.where(default: true)
		unless defaults.empty?
			defaults.each do |location|
				location.update_attributes(default: false)
			end
		end
		self.update_attributes(default: true)
	end
end