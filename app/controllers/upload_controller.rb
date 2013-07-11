class UploadController < ApplicationController
	def up
	end

	def uploadFile
		post=DataFile.save(params[:upload])
		render :text => "File has been uploaded"
	end
end
