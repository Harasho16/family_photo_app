class Photo < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :title, presence: true, length: { maximum: 30 }
  validate :image_presence

  def thumbnail
    image.variant(resize_to_limit: [ 300, 300 ])
  end

  private

  def image_presence
    errors.add(:image, :blank) unless image.attached?
  end
end
