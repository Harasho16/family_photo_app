require "net/http"
require "json"

class MyTweetController < ApplicationController
  skip_before_action :require_login

  def callback
    code = params[:code]
    return redirect_to photos_path, alert: "認可失敗" if code.blank?

    access_token = fetch_access_token(code)

    session[:oauth_access_token] = access_token

    redirect_to photos_path, notice: "MyTweeアプリと連携しました"
  end

  private

  def fetch_access_token(code)
    config = Rails.application.config.my_tweet

    response = Net::HTTP.post_form(
      URI.parse(config.token_url),
      {
        grant_type: "authorization_code",
        code: code,
        redirect_uri: config.redirect_uri,
        client_id: Rails.application.credentials.my_tweet[:client_id],
        client_secret: Rails.application.credentials.my_tweet[:client_secret]
      }
    )

    JSON.parse(response.body)["access_token"]
  end
end
