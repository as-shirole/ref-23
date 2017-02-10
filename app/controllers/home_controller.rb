class HomeController < ApplicationController
	layout 'admin', only: [:welcome]
	before_filter :authenticate_user!, only: [:welcome]
	def index
	end

	def welcome
	end
end
