require 'spreadsheet'

book = Spreadsheet::Workbook.new
sheet1 = book.create_worksheet

j=0

Tweet.all.each do |tweet|
	sheet1.row(j).push tweet.id, tweet.author, tweet.text, tweet.time, tweet.tweetid, tweet.parent_id, tweet.followers
	j+=1
end

 book.write '/Users/dhruv/Documents/6UAP/tweetGraph/app/controllers/4-15-complete.xls'
