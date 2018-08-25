class Identity < ApplicationRecord
require 'aws-sdk'
  belongs_to :user
  mount_uploader :picture, IdentityUploader
  validate :picture_size
  after_create_commit :index_face

private

  def picture_size
    if picture.size > 5.megabytes
    errors.add(:picture, "should be less than 5MB")
    end
  end
  #def index_face(bucketname,collectionname,filename)
  #
  def index_face
  @user=User.find(self.user_id)
  collection=@user.collectionid
  picture = self.picture.path.split("/").last
  external_image_name= self.name
  imagefile="uploads/identity/picture/" + self.user_id.to_s + "/" + picture.to_s
  bucketname = "idorabucket"
  puts  "***** " + external_image_id  
  #puts "******   picture  " + picture
  #puts "******   Collection  " + collection
  #puts "******   imagefile " + imagefile
  #puts "******   bucketname " + bucketname
    client = Aws::Rekognition::Client.new
      resp = client.index_faces(
      {
        #collection_id: collection
        collection_id: "ManlySeaEagles",
        image: {
          s3_object: {
            bucket: bucketname,
            name: imagefile
          },
        },
        #external_image_id: imagefile,
        #external_image_id: self.name,
        external_image_id: external_image_name,
        detection_attributes: [
        ]
      }
             )
    self.face_id=resp.face_records[0].face.face_id
    self.external_image_id = resp.face_records[0].face.external_image_id
    #puts filename
    puts "**********************aws complete"
    #self.face_id="1234"
    #self.external_image_id = "Brian_Kelly.JPG"
    self.save
  end
end
