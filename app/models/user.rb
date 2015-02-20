class User < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
		:recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:twitter]

	validates :username, :name, presence: true

	def self.from_omniauth(auth)
		# Check db if user exists, otherwise create new user record
		where(twitter_id: auth.uid).first_or_create do |user|
			user.username = auth["info"]["nickname"] #twitter handle
			user.password = Devise.friendly_token[0,20]
			user.name = auth["info"]["name"]
			user.image = auth["info"]["image"]
		end
	end
end
