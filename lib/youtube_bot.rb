class YoutubeBot
	
	attr_accessor :client

	# Initialize youtube client based on ebearfm@gmail.com app and gmail credentials
	# Must initialize client on every restart
	# Inputs: code: string - code from google auth servers to retrieve access token
	# =>      nil: - Initialize youtube client based on developer key, use this constructor for simple youtube data api queries
	# Return: none
	def initialize(code = nil)
		if code.nil?
			@client = YouTubeIt::Client.new(:dev_key => ENV['GOOGLE_DEV_KEY'])
		else
			if Rails.env.development?
				redirect_uri = "http://localhost:3000"
			elsif Rails.env.production?
				redirect_uri = "https://ebearfm.herokuapp.com"
			end

			# Exchange code for access and refresh token
			request = Typhoeus::Request.new("https://accounts.google.com/o/oauth2/token",
											method: :post,
											headers: { 'Content-Type' => "application/x-www-form-urlencoded" },
											body: { code: code.to_s,
									    			client_id: ENV['GOOGLE_CLIENT_ID'],
									    			client_secret: ENV['GOOGLE_CLIENT_SECRET'],
													redirect_uri: redirect_uri,
													grant_type: "authorization_code" })
			request.run

			response_body = JSON.parse(request.response.response_body)

			# Register client via OAuth2 with access_token
			@client = YouTubeIt::OAuth2Client.new(client_access_token: response_body["access_token"],
												  client_refresh_token: response_body["refresh_token"],
												  client_id: ENV['GOOGLE_CLIENT_ID'],
												  client_secret: ENV['GOOGLE_CLIENT_SECRET'],
												  dev_key: ENV['GOOGLE_DEV_KEY'])
		end
	end

	# Checks if url sent by twitter user is a valid youtube video url
	# Inputs: url: string - url of youtube video
	# Return: boolean - true if valid, false otherwise
	def valid_song(url)
		begin
			video = @client.video_by(url.to_s)

			return true
		resque OpenURI::HTTPError
			puts 'Invalid youtube url'

			return false
		end
	end

	# Gets youtube video object from youtube video url
	# Inputs: url: string - url of youtube video
	# Return: video: YouTubeIt::Model::Video - return video object based on url or nil if not found 
	def get_video(url)
		long_url = unshorten_url(url.to_s)

		begin
			video = @client.video_by(long_url)

			return video
		rescue OpenURI::HTTPError
			puts "Youtube Client ERROR: Could not find video"

			return nil
		end
	end

	private

	# Takes shorten url and retrieves the unshortened version (e.g. https://t.co/e1ATVRfZwm vs. http://www.youtube.com/?watch....)
	# Inputs: url: string - url of youtube video
	# Return: url: string - unshortened youtube video url
	def unshorten_url(url)
		response = Typhoeus.get(url.to_s)
		
		# parse response for unshortened url
		long_url = response.headers[:location]

		return long_url
	end
end