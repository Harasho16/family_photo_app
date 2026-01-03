require 'rails_helper'

RSpec.describe "MyTweet", type: :request do
  describe "GET /oauth/callback" do
    let(:user) { create(:user) }
    let(:access_token) { "dummy_access_token" }

    before do
      login_as(user)

      # 外部通信をスタブ
      allow_any_instance_of(MyTweetController).to receive(:fetch_access_token)
        .and_return(access_token)
    end

    it "アクセストークンをセッションに保存すること" do
      get "/oauth/callback", params: { code: "dummy_code" }

      expect(session[:oauth_access_token]).to eq(access_token)
    end

    it "写真一覧へリダイレクトすること" do
      get "/oauth/callback", params: { code: "dummy_code" }

      expect(response).to redirect_to(photos_path)
      follow_redirect!

      expect(response.body).to include("MyTweeアプリと連携しました")
    end
  end
end
