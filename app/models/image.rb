class Image < ApplicationRecord
  belongs_to :user
  has_many :images
  mount_uploader :picture, PictureUploader

  validate :picture_size
  validates :name, presence: true

private

  def picture_size
    if picture.size > 5.megabytes
    errors.add(:picture, "should be less than 5MB")
    end
  end

end
