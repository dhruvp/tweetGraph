class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets  do |t|
    	t.string :name
    	t.string :author
    	t.string :text

      t.timestamps
    end
  end
end