class Tweet < ActiveRecord::Base
	belongs_to :user

	validates :user_id, :video_id, :vid_title, presence: true
end
