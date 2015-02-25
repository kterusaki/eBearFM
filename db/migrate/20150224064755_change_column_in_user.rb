class ChangeColumnInUser < ActiveRecord::Migration
	def change
		change_column :users, :twitter_id, 'integer USING CAST(twitter_id AS integer)' 
	end
end
