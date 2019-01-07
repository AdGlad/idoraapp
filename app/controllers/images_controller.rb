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

  image_id = @image.id
  resp.labels.each do |label|
    puts "#{label.name}-#{label.confidence.to_i}"
    tagname=label.name

    if not tagname.empty?
      if not Tag.exists?(name:tagname)
        Tag.create(name:tagname, tag_type:"AWS", desc:tagname)
        puts "Creating tag record"
      else
        puts "Tag record already exists"
      end
  
      tagrec=Tag.where(name:tagname).first
  
      if not ImageTag.exists?(image_id: image_id, tag_id: tagrec.id)
        @image.tags << tagrec
        puts "Creating tag matchrecord"
      else
        puts "Tag Match record already exists"
      end
    end
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

  puts "Number of face matches [" + resp.face_matches.count.to_s + "]"
  
  if resp.face_matches.count > 0

    resp.face_matches.each do |face_matches|

      puts "#{face_matches.face.external_image_id}-#{face_matches.face.confidence.to_i}"
      matched_faceid= resp.face_matches[0].face.face_id
      puts "matched_faceid" + matched_faceid.to_s
      image_id = @image.id
      if not matched_faceid.empty?
        facematchname=Identity.where(face_id: matched_faceid).first
        if not ImageIdentity.exists?(image_id: image_id, identity_id: facematchname.id)
            @image.identities << facematchname
            puts "Creating match record"
        else
            puts "Match record already exists"
        end
      
        if not facematchname.name.empty?
            @image.matchid= facematchname.name
            @image.faces_matched= resp.to_h
        end
  
        @image.save
      
      end
    end
  else
   puts "No image face matched. Creating new identity"

   source_bucket_name = "idorabucket"
   target_bucket_name = "idorabucket"
   source_picture = @image.picture.path.split("/").last
   source_key = "uploads/image/picture/" +  Rails.env + "/" + @user.unique_id.to_s + "/" + source_picture.to_s
   target_key = "uploads/identity/picture/" +  Rails.env + "/" + @user.unique_id.to_s + "/" + source_picture.to_s
   puts "target key [" + target_key + "]"
   puts "source key [" + source_key + "]"

   s3 = Aws::S3::Client.new(region: 'eu-west-1')
   s3.copy_object({bucket: target_bucket_name, copy_source: source_bucket_name + '/' + source_key, key: target_key})
   puts "Copying file #{source_key} to #{target_key}."

   Identity.create(user_id: current_user.id, name: "Unknown", picture: @image.picture)
   puts "Creating identity record"
   collectionid=@user.collectionid
   search_faces_by_image(collectionid,"idorabucket",source_key)
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
    @image.save
    #@image = Image.create(params[:image])
    #@image = Image.create(image_params)

    respond_to do |format|
      if @image.save
        format.html { redirect_to @image, notice: 'image was successfully created.' }
        format.json { render :show, status: :created, location: imageidentity }
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
      if @image.update(image_params)
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
      imagefile="uploads/image/picture/" +  Rails.env + "/" + @user.unique_id.to_s + "/" + picture.to_s
      puts " collectionid" + collectionid
      puts imagefile
      search_faces_by_image(collectionid,"idorabucket",imagefile)
      detect_labels(collectionid,"idorabucket",imagefile)
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
