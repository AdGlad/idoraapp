class IdentifiesController < ApplicationController
  require 'aws-sdk'
  before_action :set_image, only: [:show]

def search_faces_by_image(collectionname,sourcebucketname,sourcefilename)
client = Aws::Rekognition::Client.new

resp = client.search_faces_by_image({
  collection_id: collectionname,
  face_match_threshold: 90,
  image: {
    s3_object: {
        bucket: sourcebucketname,
        name: sourcefilename,
    },
  },
  max_faces:1
})

@image.matchid= resp.face_matches[0].face.external_image_id

end

def show
#imagefile="uploads/image/picture/4/Jake_Trbojevic.JPG"
#imagefile="uploads/image/picture/4/Daily_Cherry-Evans.jpg"
#imagefile="uploads/image/picture/" + @image.user_id.to_s + "/Jake_Trbojevic.JPG"
imagefile="uploads/image/picture/" + @image.user_id.to_s + "/" + @image.picture.to_s
search_faces_by_image("ManlySeaEagles","idoraapp",imagefile)

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

