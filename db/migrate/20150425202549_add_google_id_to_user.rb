class AddGoogleIdToUser < ActiveRecord::Migration
  def change
	add_column :users, :google_id, :string
  end
end
