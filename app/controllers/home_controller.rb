class HomeController < ApplicationController
    layout 'admin', only: [:welcome, :check_out_places]
    before_filter :authenticate_user!, only: [:welcome]
    def index
    end

    def welcome
    end

    def store_locations
      coordinates_array = [params[:location][:latitude], params[:location][:longitude]]
      location =  current_user.locations.create(coordinates: coordinates_array)
    end


    def check_out_places
      @hotels = HTTParty.get("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{current_user.current_location.to_lat_long}&radius=500&key=#{ENV['GOOGLE_CLIENT_KEY']}")
    end
end
