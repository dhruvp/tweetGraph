require 'spreadsheet'

Twitter.configure do |config|
  config.consumer_key = 'RABZNMuFQIfDJrmo1dQyEw'
  config.consumer_secret = 'BD8m0A4L4NN9L8ti2IxZ8jUJBNE3Aw3SMAaP8aphFFA'
  config.oauth_token = '19520065-P8UxA1paxWGLN84yyqRpY7awdmBfHyvp29Ipx6hyl'
  config.oauth_token_secret = 'qgEGzrQaVZBd9q2QRhDDF1a7MYIflfxskGotd3s'
end

Spreadsheet.client_encoding = 'UTF-8'
book=Spreadsheet.open '/Users/dhruv/Downloads/Archive/Posts_from_2013-04-15BM.xls'
sheet1 = book.worksheet 0
i=5558
j=0
while i<=9989
	row=sheet1.row(i)
	tweet=Tweet.create(:tweetid => row[0],:time => row[1], :text=>row[3], :author=>row[4], :followers => row[6])
	if tweet.followers>5*(10**5)
		if j>=14
			sleep(900)
			j=0
		end
		begin
			retweets=Twitter.retweets(tweet.tweetid)
			j+=1
		rescue
			j+=1
		end
		retweets.each do |retweet|
			retweet_obj=Tweet.create(:text => retweet.text, :author => retweet.user.name, :time => retweet.created_at, :tweetid=>retweet.id, :elapsedtime => retweet.created_at - tweet.created_at)
			tweet.tweets << retweet_obj
		end
	end
	i+=1
end