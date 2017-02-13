class HomeController < ApplicationController
    layout 'admin', only: [:welcome]
    before_filter :authenticate_user!, only: [:welcome]
    def index
    end

    def welcome
    end

    def store_locations
      coordinates_array = [params[:location][:latitude], params[:location][:longitude]]
      location =  current_user.locations.create(coordinates: coordinates_array)
    end
end
