class AddFollowers < ActiveRecord::Migration
  def up
  	add_column :tweets, :followers, :integer
  	remove_column :tweets, :name
  end

  def down
  	remove_column :tweets, :followers
  	add_column :tweets, :name, :integer
  end
end
