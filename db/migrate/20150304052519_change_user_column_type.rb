class ChangeUserColumnType < ActiveRecord::Migration
  def change
  	change_column :users, :twitter_id, :string
  end
end
