class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :initializeTwitter

  def initializeTwitter
  	Twitter.configure do |config|
		  config.consumer_key = 'RABZNMuFQIfDJrmo1dQyEw'
		  config.consumer_secret = 'BD8m0A4L4NN9L8ti2IxZ8jUJBNE3Aw3SMAaP8aphFFA'
		  config.oauth_token = '19520065-P8UxA1paxWGLN84yyqRpY7awdmBfHyvp29Ipx6hyl'
		  config.oauth_token_secret = 'qgEGzrQaVZBd9q2QRhDDF1a7MYIflfxskGotd3s'
		end
	end
end
