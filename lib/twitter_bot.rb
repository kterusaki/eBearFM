class TwitterBot
	
	attr_accessor :client, :youtubeBot

	# TODO: Make TwitterBot client a global var and then call get_at_mentions method
	# to pull all @mention tweets
	def initialize
		@client = Twitter::REST::Client.new do |config|
			config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
			config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
			config.access_token = ENV['TWITTER_ACCESS_TOKEN']
			config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
		end

		# Initialize YoutubeBot for retrieving youtube video from url in tweet
		@youtubeBot = YoutubeBot.new
	end

	# Populates radio song queue by retrieving @mention tweets (@eBearFM) with #radio, validates 
	# that tweets come from a registered twitter user, and grabs youtube video information based on
	# youtube url song request
	# Inputs: None
	# Return: None
	def pop_play_queue
		tweets = self.get_at_mentions

		tweets.each do |tweet|
			if valid_user(tweet.user.id.to_i)
				if valid_tweet(tweet)
					shortURL = self.get_url(tweet)

					video = @youtubeBot.get_video(shortURL)

					if video.nil?
						puts "Couldn't find youtube video for #{shortURL}"
					else
						self.insert_tweet(tweet.user.id.to_i, tweet.text, video.unique_id, video.title)
					end
				end
			end
		end
	end

	# Returns @mention notifications (@eBearFM)
	def get_at_mentions
		@client.mentions_timeline
	end

	# Tweets a string for authenticated twitter user client (@eBearFM)
	# Inputs: text: string - text to tweet
	# Return: none
	def tweet(text)
		if text.size < 140
			@client.update(text)
		else
			puts "character count is greater than 140"
		end
	end

	# Inserts instance of Tweet model into database
	# Inputs: userId: integer - twitter user id
	# =>      text: string - tweet text
	# =>      video_id: string - youtube video id
	# =>      title: string - youtube video title       
	def insert_tweet(userId, text, video_id, title)
		binding.pry
		twitter_user = User.where(twitter_id: userId.to_i).take
		
		new_tweets = twitter_user.tweets.new(text: text, video_id: video_id, vid_title: title)
		new_tweets.save
	end

	# Retrieves the url in the tweet text, if it exists
	# Inputs: tweet: Twitter::Tweet - tweet object
	# Return: url: string - url of tweet or empty string
	def get_url(tweet)
		# only grabs the url from the tweet text and replaces any https with http
		tweet.text.split(' ').find { |hunk| hunk =~ /\Ahttps{0,1}:\/\/t.co/ }.gsub('https', 'http')
	end


	# Checks if a user is a registered twitter user
	# Inputs: twitter_id: integer - id of the twitter user in question
	# Return: boolean - true if the user is a valid user, false otherwise
	def valid_user(twitter_id)
		if User.where(twitter_id: twitter_id).blank?
			return false
		end
		
		return true
	end

	# Check if tweet contains #radio in text
	# Inputs: tweet: Tweet object - the tweet to be validated
	# Return: boolean - true if the tweet's text contains #radio, false otherwise
	def valid_tweet(tweet)
		if tweet.text.include? "#radio"
			return true
		end

		return false
	end
end