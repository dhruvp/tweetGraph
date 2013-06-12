class HomeController < ApplicationController
	def graph
		query=params[:query]
		begin
			saved_query=false
			status_list=[]
			if query
				status_list=Twitter.search(query, options= {:rpp=>"5",:result_type=>"popular"}).statuses
			else
				saved_query=true
			end
			data={}
			data["nodes"]=[]
			data["links"]=[]
			if !saved_query
				Tweet.delete_all
				puts 'STATUS LIST LENGTH'
				puts status_list.size
				status_list.each do |status|
					puts status.text
					original_tweet=Tweet.create(:text => status.text, :author => status.user.name, :time => status.created_at, :tweetid=>status.id, :elapsedtime => status.created_at-status.created_at)
					retweets=Twitter.retweets(original_tweet.tweetid)
					data["nodes"] << original_tweet
					if retweets.size>0
						retweets.each do |retweet|
							retweet_obj=Tweet.create(:text => retweet.text, :author => retweet.user.name, :time => retweet.created_at, :tweetid=>retweet.id, :elapsedtime => retweet.created_at - status.created_at)
							data["nodes"] << retweet_obj
							original_tweet.tweets << retweet_obj
							link={}
							link["source"]=original_tweet.id
							link["target"]=retweet_obj.id
							data["links"].append(link)
						end
					end
				end
			else
				status=Tweet.first
				data["nodes"]<<status
				status.tweets.each do |retweet|
					data["nodes"] << retweet
					link={}
					link["source"]=status.id
					link["target"]=retweet.id
					data["links"].append(link)
				end
			end
		rescue
			data={}
			data["nodes"]=['tweet1','tweet2']
			data["links"]=['']
		end
		respond_to do |format|
	    format.html
	    format.json { render :json => data }
		end
	end

	def viz
  end

  def chartviz
  end

  def chart
  	histogram= {}
  	data=[]
  	starttime = Tweet.minimum(:time)
  	ogstart=starttime
  	endtime = Tweet.maximum(:time)
  	Tweet.all.each do |tweet|
  		puts tweet.id
  		roundedtime=tweet.time.change(:min=>tweet.time.min/5*5)
  		if histogram[roundedtime]
  			histogram[roundedtime]+=1
  		else
  			histogram[roundedtime]=1
  		end
  	end
  	keyList=histogram.keys.sort!
  	sum=0
  	histogram.keys.sort!.each do |key|
  		point={}
  		point['x']=key.to_i
  		sum=sum+histogram[key]
  		point['y']=sum
  		data << point
  	end
  	respond_to do |format|
  		format.html
  		format.json {render :json => data}
  end

  	
  end

  def search
  	@query=params[:query]
  	puts @query
  	redirect_to :controller=>"home", :action=>"graph", :query=>query
  end

  def tweetinfo
  	@tweet = Tweet.find_by_id(params[:id])
  	render :partial => 'home/tweetinfo'
  end
end
