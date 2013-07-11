class Add AttachemntToCsvs < ActiveRecord::Migration
  def self.up
  	add_attachment :csvs, :atachment
  end

  def self.down
    remove_attachment :csvs, :attachment
  end
end
