require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "GET /login" do
    it "ログイン画面を表示する" do
      get login_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /login" do
    context "有効な認証情報の場合" do
      let(:user) { create(:user) }

      it "ログインしてリダイレクトする" do
        post login_path, params: { email: user.email, password: "password" }
        expect(response).to redirect_to(root_path)
        expect(session[:user_id]).to eq(user.id)
      end
    end

    context "無効な認証情報の場合" do
      it "ログイン失敗してエラーを表示" do
        post login_path, params: { email: "invalid@example.com", password: "wrong" }
        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include("メールアドレス、またはパスワードを正しく入力してください。")
      end
    end
  end

  describe "DELETE /logout" do
    let(:user) { create(:user) }

    before { login_as(user) }

    it "ログアウトしてリダイレクト" do
      delete logout_path
      expect(response).to redirect_to(login_path)
      expect(session[:user_id]).to be_nil
    end
  end
end
