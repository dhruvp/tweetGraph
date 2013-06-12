class Tweet < ActiveRecord::Base
  attr_accessible :title, :body, :text, :author, :parent_id, :time, :tweetid, :elapsedtime, :followers
	has_many :tweets, :foreign_key => "parent_id", :class_name => "Tweet"
end
