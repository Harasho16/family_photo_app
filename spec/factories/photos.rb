FactoryBot.define do
  factory :photo do
    sequence(:title) { |n| "テスト写真#{n}" }
    association :user

    after(:build) do |photo|
      photo.image.attach(
        io: File.open(Rails.root.join("spec/fixtures/files/sample.jpg")),
        filename: "sample.jpg",
        content_type: "image/jpeg"
      )
    end
  end
end
