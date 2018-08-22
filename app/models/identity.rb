class Identity < ApplicationRecord
require 'aws-sdk'
  belongs_to :user
  mount_uploader :picture, IdentityUploader
  validate :picture_size
  #filename = picture.path.split("/").last
  #imagefile="uploads/image/picture/" + self.user_id.to_s + "/" + filename.to_s
  #imagefile="uploads/image/picture/" + "1" + "/" + filename.to_s
  #after_create index_face("manlyseaeagles","ManlySeaEagles",imagefile) 
  #after_create :index_face("manlyseaeagles","ManlySeaEagles",filename) 
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
  #filename = self.picture.path.split("/").last
    client = Aws::Rekognition::Client.new
      resp = client.index_faces(
      {
        #collection_id: collectionname,
        collection_id: "ManlySeaEagles",
        image: {
          s3_object: {
            #bucket: bucketname,
            #name: filename,
            bucket: "manlyseaeagles",
            name: "Brian_Kelly.JPG",
          },
        },
        #external_image_id: filename,
        external_image_id: "Brian_Kelly.JPG",
        detection_attributes: [
        ]
      }
             )
    self.face_id=resp.face_records[0].face.face_id
    self.external_image_id = resp.face_records[0].face.external_image_id
    #self.face_id="1234"
    #self.external_image_id = "Brian_Kelly.JPG"
  end
end
