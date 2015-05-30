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

  # Retrieves user's youtube playlists
  def playlists
    youtube_bot = YoutubeBot.new(current_user.google_access_token, current_user.google_refresh_token)
    @playlists = []
    begin
    	pt_pair = youtube_bot.get_playlists 
    	@playlists = pt_pair[0]
    	access_token  = pt_pair[1]
    	#playlist_id = @playlists[0].playlist_id

    	# TODO: for each playlist, retrieve the videos in the playlist
    	# Create a map, where key is playlist_id and value is array of youtube video objects
    	# Create method to get videos by playlist
    	@p_vids = Hash.new # A hash where key is playlist_id and value is an array of videos for that playlist
    	@playlists.each do |playlist|
        @p_vids[playlist.playlist_id] = youtube_bot.get_playlist_videos(playlist.playlist_id)
    	end

    	#binding.pry
    	#puts format_time(341)

    	# Update google access token if one is returned
    	if !access_token.nil?
    		puts "Updating access token"
    		current_user.update(google_access_token: access_token)
    	end
    rescue Exception => error
    	flash.now[:error] = error.to_s
    	render 'playlists'
    end
  end

  # Formats seconds to minutes and seconds
  # Inputs: seconds - integer
  # Return: string - formatted like m:ss
  def format_time(seconds)
		Time.at(seconds).utc.strftime("%-M:%S")
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