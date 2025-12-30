require "rails_helper"

RSpec.describe Photo, type: :model do
  describe "バリデーション" do
    it "正常な値であれば通ること" do
      photo = build(:photo)
      expect(photo).to be_valid
    end

    context "エラーパターン" do
      it "タイトルが未入力だとエラーとなること" do
        photo = build(:photo, title: "")
        expect(photo).to be_invalid
        expect(photo.errors[:title]).to include("を入力してください")
      end

      it "タイトルが30文字を超えるとエラーとなること" do
        photo = build(:photo, title: "a" * 31)
        expect(photo).to be_invalid
      end

      it "画像が未添付だとエラーとなること" do
        photo = build(:photo)
        photo.image.detach

        expect(photo).to be_invalid
        expect(photo.errors[:image]).to be_present
      end
    end
  end

  describe "ActiveStorage" do
    it "画像が添付できること" do
      photo = build(:photo)
      expect(photo.image).to be_attached
    end
  end
end
