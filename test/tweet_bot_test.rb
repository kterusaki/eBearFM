require 'test_helper'

class TweetBotTest < ActionController::TestCase
	# test "the truth" do
	#   assert true
	# end

	test "tweeting" do
		binding.pry
		twitbot = TwitterBot.new
		twitbot.tweet("I'm tweeting with the twitter gem!")

		puts twitbot
	end
end