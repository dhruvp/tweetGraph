class AddParentId < ActiveRecord::Migration
  def up
  	add_column :tweets, :parent_id, :integer
  end

  def down
  	drop_column :tweets, :parent_id
  end
end
