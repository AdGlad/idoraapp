class Image < ApplicationRecord
  require 'aws-sdk'
  belongs_to :user
  #has_many :images
  has_many :image_tags
  has_many :tags, through: :image_tags
  has_many :image_identities
  has_many :identities, through: :image_identities
  has_many :labels
  mount_uploader :picture, PictureUploader
  validate :picture_size
  #validates :name, presence: true

  before_save :default_name
  
  def default_name
       
    #self.name ||= "file"
    #self.name = picture.path.split("/").last
    self.name = picture.url
    #self.name ||= File.basename(picture.filename, '.*').titleize if picture
  end

private
  def picture_size
    if picture.size > 5.megabytes
    errors.add(:picture, "should be less than 5MB")
    end
  end

end
