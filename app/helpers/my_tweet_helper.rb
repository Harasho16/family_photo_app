module MyTweetHelper
  def my_tweet_connected?
    session[:oauth_access_token].present?
  end

  def my_tweet_authorize_url
    config = Rails.application.config.my_tweet

    "#{config.authorize_url}?" + {
      response_type: "code",
      client_id: Rails.application.credentials.my_tweet[:client_id],
      redirect_uri: config.redirect_uri,
      scope: config.scope,
      state: nil
    }.to_query
  end
end
