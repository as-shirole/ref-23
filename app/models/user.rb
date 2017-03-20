class User
  include Mongoid::Document
  include Mongoid::Paperclip
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:google_oauth2, :facebook]

  ## Database authenticatable
  field :name,         type: String
  field :status, type: String  , default: "offline"
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time
  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String
  field :provider,           type: String
  field :uid,                type: String
  field :omniauth_image,     type: String
  has_mongoid_attached_file :avatar
  
  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: 

  #Associaltions
  has_many :posts
  # has_many :messages
  embeds_many :locations, cascade_callbacks: true
  has_many :tokens



  def self.from_omniauth(access_token)
      data = access_token.info
      user = User.where(:email => data["email"]).first
      extra_data = access_token["extra"]["raw_info"]
      # Uncomment the section below if you want users to be created if they don't exist
      unless user
          user = User.create(name: data["name"],
             email: data["email"],
             password: Devise.friendly_token[0,20],
             provider: access_token["provider"],
             uid: access_token["uid"],
             omniauth_image: extra_data["picture"].nil? ? data["image"] : extra_data["picture"]
          )
      end
      user
  end

  def current_location
    return nil if self.locations.empty? 
    self.locations.where(default: true).last
  end

  def collect_places
    return {} if self.current_location.nil?
  end

  def self.public_key
    "BJuccfOaFcYTVlAZgoMC1CzZPb1723fPUj6HkKYnIqxkO3ZMC7QosX6-uuNipOvjsvHajDWzfLPhcO0a_FohrYc="
    # ENV.fetch('VAPID_PUBLIC_KEY')
  end

  def self.public_key_bytes
    Base64.urlsafe_decode64(public_key).bytes
  end

  def self.private_key
    "SLLIX7KIK4ZpSwuxXNdpISZwEGY74TnbjI4fil4GoKw="
    # ENV.fetch('VAPID_PRIVATE_KEY')
  end

  def broacast_message
    p "called"
    ActionCable.server.broadcast "web_notifications_#{self.id}", { title: 'New things!', body: 'All the news that is fit to print' }
  end

  def personal_message(message, tag)
    return true if self.tokens.empty?
    self.tokens.each do |token| 
      p "sending push notification"
      message = {title: message, body: "This is welcome notification sent by https://the-resume.herokuapp.com", 
                 icon: "assets/move-up.png", tag: tag}
      Webpush.payload_send( message: message.to_json, endpoint: token.web_token, p256dh: token.p256dh, auth: token.auth,
        vapid: { subject: "mailto:ross@rossta.net", public_key: ENV['WEB_PUSH_PUBLIC_KEY'], private_key: ENV['WEB_PUSH_PRIVATE_KEY'] })
      p "after sending push notification"
    end
  end

  def first_notification
    return true if self.tokens.empty?
    self.tokens.each do |token| 
      p "sending push notification"
      message = {title: "Thanks for Signing up/in. We're happy to serve you.", body: "This is welcome notification sent by https://the-resume.herokuapp.com", 
                 icon: "assets/move-up.png", tag: "#{ENV['SERVER_ADDRESS']}/chat_rooms"}
      Webpush.payload_send( message: message.to_json, endpoint: token.web_token, p256dh: token.p256dh, auth: token.auth,
        vapid: { subject: "mailto:ross@rossta.net", public_key: ENV['WEB_PUSH_PUBLIC_KEY'], private_key: ENV['WEB_PUSH_PRIVATE_KEY'] })
      p "after sending push notification"
    end
  end
end