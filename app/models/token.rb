require 'webpush'
class Token
  include Mongoid::Document
  field :web_token, type: String
  field :user_id, type: String
  field :auth, type: String
  field :p256dh, type: String
  field :last_messsage_sent_at, type: Date, default: ->{ Date.today }

  belongs_to :user
  after_create :send_web_notification



  def send_web_notification()
    p "sending push notification"
    message = {title: "Welcome. Thanks for stopping by.", body: "This is welcome notification sent by https://the-resume.herokuapp.com", 
               icon: "assets/move-up.png", tag: "welcome-mesage"}
  	Webpush.payload_send( message: message.to_json, endpoint: self.web_token, p256dh: self.p256dh, auth: self.auth,
      vapid: { subject: "mailto:ross@rossta.net", public_key: ENV['WEB_PUSH_PUBLIC_KEY'], private_key: ENV['WEB_PUSH_PRIVATE_KEY'] })
    p "after sending push notification"
  end

  def existing_record_message
    p "===================="
  end


  def existing_record_with_user_message

  end
end