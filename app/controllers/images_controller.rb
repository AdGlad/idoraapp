class ImagesController < ApplicationController
  require 'aws-sdk'
  before_action :set_image, only: [:check, :show, :edit, :update, :destroy]

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
  @label=@image.labels.create(name: label.name)
  @label.save
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
  resp.face_matches.each do |face_matches|
    puts "#{face_matches.face.external_image_id}-#{face_matches.face.confidence.to_i}"
  end

  matched_faceid= resp.face_matches[0].face.face_id
  puts "matched_faceid" + matched_faceid.to_s
 image_id = @image.id
  if not matched_faceid.empty?
    facematchname=Identity.where(face_id: matched_faceid).first
    #@image.matchid=resp.face_matches[0].face.external_image_id 
    if not ImageIdentity.exists?(image_id: image_id, identity_id: facematchname.id)
      @image.identities << facematchname
      puts "Creating match record"
    else
      puts "Match record already exists"
    end

    if not facematchname.name.empty?
      @image.matchid= facematchname.name
      @image.faces_matched= resp.to_h
      #@imagematch = Imagematch.new(name: @image.matchid, desc: resp.face_matches[0].face.external_image_id, resp: resp.to_h, image_id: @image.id) 
      #@imagematch.save
    end
    @image.save

  end
end
  #
    # GET /images
    # GET /images.json
  
def index
  @images = Image.where(user_id: current_user.id).paginate(page: params[:page], per_page: 5)
end
  
  # GET /images/1
  # GET /images/1.json
  def show
      @labels = Label.where(image_id: @image.id).paginate(page: params[:page], per_page: 5)
  end

  # GET /images/new
  def new
    @image = Image.new
  end

  # GET /images/1/edit
  def edit
  end

  # POST /images
  # POST /images.json
  def create

    @image = Image.new(image_params)
    @image.user = current_user

    respond_to do |format|
      if @image.save
        format.html { redirect_to @image, notice: 'Image was successfully created.' }
        format.json { render :show, status: :created, location: @image }
      else
        format.html { render :new }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /images/1
  # PATCH/PUT /images/1.json
  def update
    respond_to do |format|
      if @image.update(image_params)
        format.html { redirect_to @image, notice: 'Image was successfully updated.' }
        format.json { render :show, status: :ok, location: @image }
      else
        format.html { render :edit }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    @image.destroy
    respond_to do |format|
      format.html { redirect_to images_url, notice: 'Image was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def check
    respond_to do |format|
       if @image.matchid="'Cherry-Evans" 
      #if @image.update(image_params)
        format.html { redirect_to @image, notice: 'Image was successfully updated.' }
        format.json { render :show, status: :ok, location: @image }
      else
        format.html { render :edit }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  def match
      @image = Image.find(params[:id])
      @user = User.find(@image.user_id)
      collectionid=@user.collectionid
      picture = @image.picture.path.split("/").last
      imagefile="uploads/image/picture/" +  Rails.env + "/" + @image.user_id.to_s + "/" + picture.to_s
      puts " collectionid" + collectionid
      puts imagefile
  ##search_faces_by_image("ManlySeaEagles","idorabucket",imagefile)
      search_faces_by_image(collectionid,"idorabucket",imagefile)
      detect_labels(collectionid,"idorabucket",imagefile)
  ##  recognize_celebrities("idorabucket",imagefile)
  ##@image.matchid="'Cherry-Evans"
  #@image.save
      render "show"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_image
      @image = Image.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def image_params
      params.require(:image).permit(:name, :picture, :user_id)
    end
end
