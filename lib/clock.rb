require 'clockwork'
require './config/boot'
require './config/environment'

module Clockwork
	every(1.minutes, 'Queueing tweet puller job') {
		Delayed::Job.enqueue TweetPuller.new, :queue => 'play_queue'
	}

	# TODO: Add schedule to refresh youtube bot token every 1 hour
	# Create a method refresh_token in youtube_bot class and call it below
	# every(1.hour 'Refresh youtube bot token') {
	# 	Delayed::Job.enqueue ...
	# }
end