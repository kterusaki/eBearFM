Rails.application.config.after_initialize do
	# Initialize persistant TwitterBot instance
	TWITBOT = TwitterBot.new
end