class IdentifiesController < ApplicationController
  require 'aws-sdk'
  before_action :set_image, only: [:show]

def detect_labels(collectionname,sourcebucketname,sourcefilename)
client = Aws::Rekognition::Client.new

resp = client.detect_labels({
  image: {
    s3_object: {
        bucket: sourcebucketname,
        name: sourcefilename,
    },
  },
  max_labels:10
})

puts "*********************"
puts resp.to_h
puts "*********************"

resp.labels.each do |label|
  puts "#{label.name}-#{label.confidence.to_i}"
end

@image.scene_matched= resp.to_h

end

def search_faces_by_image(collectionname,sourcebucketname,sourcefilename)
client = Aws::Rekognition::Client.new

resp = client.search_faces_by_image({
  collection_id: collectionname,
  face_match_threshold: 60,
  image: {
    s3_object: {
        bucket: sourcebucketname,
        name: sourcefilename,
    },
  },
  max_faces:10
})

puts "*********************"
puts resp
puts "*********************"

resp.face_matches.each do |face_matches|
  puts "#{face_matches.face.external_image_id}-#{face_matches.face.confidence.to_i}"
end
matched_faceid= resp.face_matches[0].face.face_id

if not matched_faceid.empty?
  #puts "*********************"
  #puts matched_faceid
  #puts "*********************"
  facematchname=Identity.where(face_id: matched_faceid).first
  #puts "*********************"
  #puts facematchname.name
  #puts "*********************"
  #@image.matchid=resp.face_matches[0].face.external_image_id 
  
  if not facematchname.name.empty?
    @image.matchid= facematchname.name
    @image.faces_matched= resp.to_h
    #@imagematch = Imagematch.new(name: @image.matchid, desc: resp.face_matches[0].face.external_image_id, resp: resp.to_h, image_id: @image.id) 
    #@imagematch.save
  end 
end 

end

def recognize_celebrities(sourcebucketname,sourcefilename)
  client = Aws::Rekognition::Client.new
  
  resp = client.recognize_celebrities({
    image: {
      s3_object: {
          bucket: sourcebucketname,
          name: sourcefilename,
      },
    },
  })
  
  
  resp.celebrity_faces.each do |celebrity_faces|
    puts "#{celebrity_faces.name}-#{celebrity_faces.face.confidence.to_i}"
    @image.celebrity= celebrity_faces.name
  end
end



def show
  @image = Image.find(params[:id])
  @user = User.find(@image.user_id)
  collectionid=@user.collectionid
  picture = @image.picture.path.split("/").last
  imagefile="uploads/image/picture/" + @image.user_id.to_s + "/" + picture.to_s
  puts " collectionid" + collectionid
  puts picture.to_s
  puts imagefile
  #search_faces_by_image("ManlySeaEagles","idorabucket",imagefile)
  search_faces_by_image(collectionid,"idorabucket",imagefile)
  detect_labels(collectionid,"idorabucket",imagefile)
  recognize_celebrities("idorabucket",imagefile)
  #@image.matchid="'Cherry-Evans"
  @image.save

end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_image
    @image = Image.find(params[:id])
  end
  
  # Never trust parameters from the scary internet, only allow the white list through.
  def image_params
    params.require(:image).permit(:name, :picture, :user_id, :matchid)
  end
end

