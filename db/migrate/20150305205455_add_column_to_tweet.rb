class AddColumnToTweet < ActiveRecord::Migration
  def change
    add_column :tweets, :played, :Bool
    add_column :tweets, :username, :string
  end
end
