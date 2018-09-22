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
  #after_commit :search_faces_by_image
  validate :picture_size
  validates :name, presence: true

private
  def picture_size
    if picture.size > 5.megabytes
    errors.add(:picture, "should be less than 5MB")
    end
  end

  def search_faces_by_image
    @user=User.find(self.user_id)
    collectionid=@user.collectionid 
    client = Aws::Rekognition::Client.new
    bucketname= "idorabucket"
    user_unique_id = @user.unique_id.to_s
    imagefile="uploads/image/picture/" +  Rails.env + "/" + user_unique_id + "/" + picture.to_s
    #imagefile="uploads/image/picture/" +  Rails.env + "/" + self.user_id.to_s + "/" + picture.to_s
    #imagefile="uploads/image/picture/development/3/player16.jpg"
    resp = client.search_faces_by_image({
                   collection_id: collectionid,
                   face_match_threshold: 60,
                   image: {
                       s3_object: {
                           bucket: bucketname,
                           name: imagefile,
                                  },
                          },
                     max_faces:10
                   })

    resp.face_matches.each do |face_matches|
      puts "#{face_matches.face.external_image_id}-#{face_matches.face.confidence.to_i}"
    end

    matched_faceid= resp.face_matches[0].face.face_id
  
    if not matched_faceid.empty?
      facematchname=Identity.where(face_id: matched_faceid).first
      if not ImageIdentity.exists?(identity_id: facematchname.id)
        self.identities << facematchname
      else
        puts "Match record already exists"
      end
      if not facematchname.name.empty?
        self.matchid= facematchname.name
        self.faces_matched= resp.to_h
        self.save
      end
    end
end
end
