class DataFile < ActiveRecord::Base
  # attr_accessible :title, :body
  has_attached_file :file
  def self.save(upload)
  	name = upload['datafile'].original_filename
  	directory="public/data"
  	path=File.join(directory,name)
  	File.open(path,"wb") {
  		|f| f.write(upload['datafile'].read)
  	}
	end
end

