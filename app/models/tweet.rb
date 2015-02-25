class Tweet < ActiveRecord::Base
	belongs_to :user

	validates :user_id, :tweet_id, :video_id, :vid_title, presence: true
	validates :tweet_id, uniqueness: true
end
