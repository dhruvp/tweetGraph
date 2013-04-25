class RecreateConnections < ActiveRecord::Migration
  def change
    create_table :tweet_connections, :force => true, :id => false do |t|
      t.integer :tweet_id
      t.integer :retweet_id

      t.timestamps
    end
  end
end
