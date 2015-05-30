class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:twitter, :google_oauth2]

  has_many :tweets

  validates :username, :name, :twitter_id, presence: true
  validates :twitter_id, uniqueness: true 

  def self.from_omniauth(auth)
    # Check db if user exists, otherwise create new user record
    where(twitter_id: auth.uid).first_or_create do |user|
      user.username = auth["info"]["nickname"] #twitter handle
      user.password = Devise.friendly_token[0,20]
      user.name = auth["info"]["name"]
      user.image = auth["info"]["image"]
    end
  end

  # Updates a user record with google auth credentials
  # Inputs: auth - JSON object containing a user's google information
  # Return: none
  def self.from_omniauth_youtube(auth, current_user)
      current_user.email = auth[:info][:email]
      current_user.google_access_token = auth[:credentials][:token]

      if !auth[:credentials][:refresh_token].nil?
        current_user.google_refresh_token = auth[:credentials][:refresh_token]
      end

      if !current_user.save
        current_user.errors.to_yaml
      end
  end

  # TODO: Finish this function, implement more methods in youtube bot class
  # Retrieves a youtube user's playlists
  # Inputs: none
  # Return: an array
  def self.get_playlists

  end
end
