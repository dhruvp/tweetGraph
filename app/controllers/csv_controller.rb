class CsvController < ApplicationController
	def create
  @csv = Csv.create( params[:csv] )
  # your save and redirect code here
end

def show
  @csv = Csv.find(params[:id])      
end

end
