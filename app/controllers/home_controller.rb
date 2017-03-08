class HomeController < ApplicationController
    layout 'admin', only: [:welcome, :check_out_places]
    before_filter :authenticate_user!, only: [:welcome]
    def index
    end

    def welcome
      result = request.location
      p "================================#{request.location.inspect}================================="
    end

    def store_locations
      coordinates_array = [params[:location][:latitude], params[:location][:longitude]]
      location =  current_user.locations.create(coordinates: coordinates_array)
    end


    def check_out_places
      hotels = HTTParty.get("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{current_user.current_location.to_lat_long}&keyword=hotels&radius=500&key=#{ENV['GOOGLE_CLIENT_KEY']}")
      @hotels = hotels["results"]
    end


    def notification
      Rails.logger.info "Sending push notification from #{push_params.inspect}"
    subscription_params = fetch_subscription_params
    
    token = Token.new
    token.web_token = subscription_params[:endpoint]
    token.p256dh = subscription_params.dig(:keys, :p256dh)
    token.auth = subscription_params.dig(:keys, :auth)
    p "============================"
    p token.save!
    User.send_notification fetch_message,
      endpoint: subscription_params[:endpoint],
      p256dh: subscription_params.dig(:keys, :p256dh),
      auth: subscription_params.dig(:keys, :auth)

    head :ok
    end


    private

      def push_params
        params.permit(:message, { subscription: [:endpoint, keys: [:auth, :p256dh]]})
      end

      def fetch_message
        push_params.fetch(:message, "Yay, you sent a push notification!")
      end

      def fetch_subscription_params
        @subscription_params ||= push_params.fetch(:subscription) { extract_session_subscription }
      end

      def extract_session_subscription
        subscription = session.fetch(:subscription) { raise PushNotificationError,
                                                              "Cannot create notification: no :subscription in params or session" }

        JSON.parse(subscription).with_indifferent_access
      end


end
