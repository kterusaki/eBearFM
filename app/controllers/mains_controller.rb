class MainsController < ApplicationController
	respond_to :html, :json

	def home
		@tweets = Tweet.where(played: false, user_id: current_user.id, created_at: (Time.now - 100.day)..Time.now)

		respond_to do |format|
			format.html

			format.json {
				render :json => @tweets
			}
		end
	end

	def update_tweet
		respond_to do |format|
			format.json {
				render :json => true
				update_tweet_helper(params["video_id"])
			} 
		end
	end

	private

	# Helper method for setting a tweet and corresponding video to played
	# Inputs: videoId (string) - id of the youtube video
	# Return: None
	def update_tweet_helper(videoId)
		tweet = Tweet.where(video_id: videoId).take
		tweet.played = true

		tweet.save
	end
end