require 'rails_helper'

RSpec.describe User, type: :model do
  it "有効なファクトリを持つこと" do
    user = build(:user)
    expect(user).to be_valid
  end

  it "email は小文字に正規化されること" do
    user = create(:user, email: "TEST@EXAMPLE.COM")
    expect(user.email).to eq "test@example.com"
  end

  it "email は一意であること（大文字小文字区別なし）" do
    create(:user, email: "test@example.com")
    user = build(:user, email: "TEST@EXAMPLE.COM")

    expect(user).not_to be_valid
  end
end
