require 'rails_helper'

RSpec.describe "Photos", type: :request do
  describe "GET /index" do
    let(:user) { create(:user) }
    let!(:photos) { create_list(:photo, 3, user: user) }

    before { login_as(user) }

    it "ログインユーザーの写真だけ表示されること" do
      other_user = create(:user)
      other_photos = create_list(:photo, 2, user: other_user)

      get photos_path

      expect(assigns(:photos).count).to eq(3)
      expect(assigns(:photos)).to all(have_attributes(user_id: user.id))
    end

    it "未ログインだとログイン画面へ遷移すること" do
      delete logout_path
      get photos_path

      expect(response).to redirect_to(login_path)
    end
  end

  describe "GET /new" do
    let(:user) { create(:user) }

    it "ログインユーザーがアクセスできること" do
      login_as(user)
      get new_photo_path

      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /create" do
    let(:user) { create(:user) }

    before { login_as(user) }

    context "有効なパラメータの場合" do
      let(:valid_params) do
        {
          photo: {
            title: "新しい写真",
            image: fixture_file_upload(Rails.root.join("spec/fixtures/files/sample.jpg"), "image/jpeg")
          }
        }
      end

      it "写真が作成されること" do
        expect {
          post photos_path, params: valid_params
        }.to change(Photo, :count).by(1)
      end

      it "写真一覧へリダイレクトされること" do
        post photos_path, params: valid_params

        expect(response).to redirect_to(photos_path)
      end
    end

    context "無効なパラメータの場合" do
      let(:invalid_params) do
        {
          photo: {
            title: "",
            image: fixture_file_upload(Rails.root.join("spec/fixtures/files/sample.jpg"), "image/jpeg")
          }
        }
      end

      it "写真が作成されないこと" do
        expect {
          post photos_path, params: invalid_params
        }.not_to change(Photo, :count)
      end

      it "newテンプレートがレンダリングされること" do
        post photos_path, params: invalid_params

        expect(response).to have_http_status(:unprocessable_content)
        expect(response).to render_template(:new)
      end
    end
  end
end
