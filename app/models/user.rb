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
  embeds_many :posts
  embeds_many :locations, cascade_callbacks: true



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

end