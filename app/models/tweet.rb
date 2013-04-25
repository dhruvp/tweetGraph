class Tweet < ActiveRecord::Base
  attr_accessible :title, :body, :text, :author, :name, :parent_id, :time, :tweetid, :elapsedtime
	has_many :tweets, :foreign_key => "parent_id", :class_name => "Tweet"
end
