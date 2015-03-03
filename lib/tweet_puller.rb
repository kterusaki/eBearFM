# Pulls tweets from Twitter user notifications

class TweetPuller
	def perform
		TWITBOT.pop_play_queue
	end

	def success(job)
		puts "Job [#{job.id}] success in #{job.queue}"
	end

	def error(job, exception)
		puts "Delayed job error #{exception}"
	end
end