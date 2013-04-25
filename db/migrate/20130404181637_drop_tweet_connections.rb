class DropTweetConnections < ActiveRecord::Migration
  def up
  	drop_table :tweet_connections
  end

  def down
  	raise ActiveRecord::IrreversibleMigration
  end
end
