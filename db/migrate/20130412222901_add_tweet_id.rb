class AddTweetId < ActiveRecord::Migration
  def up
  	add_column :tweets, :tweetid, :integer
  end

  def down
  	remove_column :tweets, :tweetid
  end
end
