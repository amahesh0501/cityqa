class User < ActiveRecord::Base
  has_many :answers
  has_many :questions
  has_many :votes
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  devise :omniauthable, :omniauth_providers => [:facebook]

  def self.find_for_facebook_oauth(auth)
     where(auth.slice(:provider, :uid)).first_or_create do |user|
       user.provider = auth.provider
       user.uid = auth.uid
       user.email = auth.info.email
       user.name = auth.info.name   # assuming the user model has a name
       user.password = Devise.friendly_token[0,20]
       user.oauth_token = auth.credentials.token
       user.oauth_expires_at = Time.at(auth.credentials.expires_at)
       # user.image = auth.info.image # assuming the user model has an image
     end
   end

  def self.new_with_session(params, session)
     super.tap do |user|
       if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
         user.email = data["email"] if user.email.blank?
       end
     end
   end

   def facebook
       @facebook ||= Koala::Facebook::API.new(oauth_token)
       block_given? ? yield(@facebook) : @facebook
     rescue Koala::Facebook::APIError => e
       logger.info e.to_s
       nil # or consider a custom null object
   end

  def friends_in_city(city)
    friend_array = self.facebook.get_connection('me', 'friends?fields=id,name,location')
    friend_array.select { |f| f['location']['name'].split(',').first == city if f['location']}
  end


end