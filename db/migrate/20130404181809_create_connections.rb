class CreateConnections < ActiveRecord::Migration
  def change
    create_table :connections do |t|
      t.integer :tweet_id
      t.integer :retweet_id

      t.timestamps
    end
  end
end
