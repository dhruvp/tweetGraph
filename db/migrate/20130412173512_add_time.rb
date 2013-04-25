class AddTime < ActiveRecord::Migration
  def up
  	add_column :tweets, :time, :datetime
  end

  def down
  	remove_column :tweets, :time
  end
end
