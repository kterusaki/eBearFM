class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :user_id
      t.string :text
      t.string :video_id
      t.string :vid_title

      t.timestamps null: false
    end
  end
end
