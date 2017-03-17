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
    message = {title: "Welcome. Thanks for stopping by.", body: "Click here to keep in touch", 
               icon: "assets/move-up.png", tag: "http://127.0.0.1:5000#contact", targetUrl: "http://www.google.com"}
  	Webpush.payload_send( message: message.to_json, endpoint: self.web_token, p256dh: self.p256dh, auth: self.auth,
      vapid: { subject: "mailto:ross@rossta.net", public_key: ENV['WEB_PUSH_PUBLIC_KEY'], private_key: ENV['WEB_PUSH_PRIVATE_KEY'] })
  end

  def existing_record_message
    # message = {title: "Welcome Back", body: "Thanks for coming back. Enjoy our private chat functionality", 
    #            icon: "assets/move-up.png", tag: "http://127.0.0.1:5000#contact", targetUrl: "http://www.google.com"}
    # Webpush.payload_send( message: message.to_json, endpoint: self.web_token, p256dh: self.p256dh, auth: self.auth,
    #   vapid: { subject: "mailto:ross@rossta.net", public_key: ENV['WEB_PUSH_PUBLIC_KEY'], private_key: ENV['WEB_PUSH_PRIVATE_KEY'] })
  end


  def existing_record_with_user_message

  end
end