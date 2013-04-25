class AddTimeElapsed < ActiveRecord::Migration
  def up
  	add_column :tweets, :elapsedtime, :datetime
  end

  def down
  	remove_column :tweets, :elapsedtime
  end
end
