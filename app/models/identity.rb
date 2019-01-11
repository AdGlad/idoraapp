class Identity < ApplicationRecord
require 'aws-sdk'
  belongs_to :user
  mount_uploader :picture, IdentityUploader
  validate :picture_size
  validates :name, presence: true
  after_create_commit :index_face
  has_many :image_identities
  has_many :images, through: :image_identities

private

  def picture_size
    if picture.size > 5.megabytes
    errors.add(:picture, "should be less than 5MB")
    end
  end

  def index_face
  @user=User.find(self.user_id)
  collectionid=@user.collectionid
  puts "******   picture  " + picture.to_s
  picture = self.picture.path.split("/").last
  user_unique_id = @user.unique_id.to_s
  imagefile="uploads/identity/picture/" + Rails.env + "/" + user_unique_id + "/" + picture.to_s
  bucketname = "idorabucket"
  puts "******   picture  " + picture.to_s
  puts "******   user_unique_id  " + user_unique_id
  puts "******   Collection  " + collectionid
  puts "******   imagefile " + imagefile
  puts "******   bucketname " + bucketname
    client = Aws::Rekognition::Client.new
      resp = client.index_faces(
      {
        collection_id: collectionid,
        image: {
          s3_object: {
            bucket: bucketname,
            name: imagefile
          },
        },
        external_image_id: picture,
        detection_attributes: [
        ]
      }
             )
    self.face_id=resp.face_records[0].face.face_id
    self.external_image_id = resp.face_records[0].face.external_image_id
    puts "**********************aws complete"
    self.save
  end
end
