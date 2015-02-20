class AddColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :username, :string
    add_column :users, :name, :string
    add_column :users, :image, :string
    add_column :users, :twitter_id, :string
  end
end
