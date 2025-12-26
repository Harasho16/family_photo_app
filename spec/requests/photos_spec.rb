require 'rails_helper'

RSpec.describe "Photos", type: :request do
  describe "GET /index" do
    let(:user) { create(:user) }

    before { login_as(user) }

    it "一覧画面を表示する" do
      get photos_path
      expect(response).to have_http_status(:success)
    end
  end
end
