Rails.application.config.my_tweet = ActiveSupport::OrderedOptions.new

Rails.application.config.my_tweet.authorize_url = "http://unifa-recruit-my-tweet-app.ap-northeast-1.elasticbeanstalk.com/oauth/authorize"
Rails.application.config.my_tweet.token_url     = "http://unifa-recruit-my-tweet-app.ap-northeast-1.elasticbeanstalk.com/oauth/token"
Rails.application.config.my_tweet.redirect_uri  = "http://localhost:3000/oauth/callback"
Rails.application.config.my_tweet.scope         = "write_tweet"
Rails.application.config.my_tweet.tweet_uri     = "http://unifa-recruit-my-tweet-app.ap-northeast-1.elasticbeanstalk.com/api/tweets"
