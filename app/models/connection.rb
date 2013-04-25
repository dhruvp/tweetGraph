class Connection < ActiveRecord::Base
  attr_accessible :integer, :integer
  belongs_to :tweet
end
