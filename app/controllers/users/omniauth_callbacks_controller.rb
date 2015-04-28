class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
	# You should configure your model like this:
	# devise :omniauthable, omniauth_providers: [:twitter]

	# You should also create an action method in this controller like this:
	# def twitter
	# end

	# More info at:
	# https://github.com/plataformatec/devise#omniauth

	# GET|POST /resource/auth/twitter
	# def passthru
	#   super
	# end

	# GET|POST /users/auth/twitter/callback
	# def failure
	#   super
	# end

	# protected

	# The path used when omniauth fails
	# def after_omniauth_failure_path_for(scope)
	#   super(scope)
	# end

	def twitter
		@auth = request.env["omniauth.auth"]
		@user = User.from_omniauth(request.env["omniauth.auth"])

		sign_in_and_redirect @user
	end

	# Pass in current signed in user
	# This method will only get called when they have already signed in with twitter
	def google_oauth2
		@auth = request.env["omniauth.auth"]
		@user = User.from_omniauth_youtube(request.env["omniauth.auth"], current_user)

		redirect_to playlists_path
	end
end
