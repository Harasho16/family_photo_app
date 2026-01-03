require "net/http"
require "json"

class PhotosController < ApplicationController
  def index
    @photos = current_user.photos
                          .with_attached_image
                          .order(created_at: :desc)
  end

  def new
    @photo = Photo.new
  end

  def create
    @photo = current_user.photos.build(photo_params)

    if @photo.save
      redirect_to photos_path, notice: "写真をアップロードしました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def tweet
    photo = current_user.photos.find(params[:id])
    token = session[:oauth_access_token]

    if token.blank?
      Rails.logger.warn(
        "[MyTweet] oauth_access_token missing. user_id=#{current_user.id}, photo_id=#{photo.id}"
      )
      return redirect_to photos_path
    end

    response = post_tweet(photo, token)

    if response.is_a?(Net::HTTPSuccess)
      redirect_to photos_path, notice: "ツイートしました"
    else
      redirect_to photos_path, alert: "ツイートに失敗しました"
    end
  end

  private

  def photo_params
    params.require(:photo).permit(:title, :image)
  end

  def post_tweet(photo, token)
    uri = URI.parse(tweet_url)

    http = Net::HTTP.new(uri.host, uri.port)

    request = Net::HTTP::Post.new(uri.path, {
      "Content-Type"  => "application/json",
      "Authorization" => "Bearer #{token}"
    })

    request.body = {
      text: photo.title,
      url: rails_blob_url(photo.image, only_path: false)
    }.to_json

    http.request(request)
  end

  def tweet_url
    Rails.application.config.my_tweet.tweet_uri
  end
end
