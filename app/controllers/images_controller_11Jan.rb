class ImagesController < ApplicationController
  require 'mini_magick'
  require 'aws-sdk'
  require 'fileutils'
  before_action :set_image, only: [:check, :show, :edit, :update, :destroy]

def detect_labels(collectionname,bucketname,sourcefilename)
client = Aws::Rekognition::Client.new

resp = client.detect_labels({
  image: {
    s3_object: {
        bucket: bucketname,
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

def create_face_match_record(matchedfaceid,match_response)
 
      ##matched_faceid= resp.face_matches[0].face.face_id
      #matched_faceid= face_matches.face.face_id
      image_id = @image.id
      if not matchedfaceid.empty?
        facematchname=Identity.where(face_id: matchedfaceid).first
        if not ImageIdentity.exists?(image_id: image_id, identity_id: facematchname.id)
            puts "Creating match record"
            @image.identities << facematchname
        else
            puts "Match record already exists"
        end
      
        if not facematchname.name.empty?
            @image.matchid= facematchname.name
            @image.faces_matched=match_response.to_h
        end
  
        @image.save
    end
end

def create_identity_from_image(collectionname,bucketname,sourcefilename)
  puts "########################################################################"
  puts "create_identity_from_image(collectionname,bucketname,sourcefilename)"
  puts "[" + collectionname + "]"
  puts "[" + bucketname + "]"
  puts "[" + sourcefilename + "]"
  puts "########################################################################"

   s3 = Aws::S3::Client.new(region: 'eu-west-1')

   #imageFile = MiniMagick::Image.open("https://s3-eu-west-1.amazonaws.com/" + bucketname + "/" + sourcefilename)
   #imageFile = MiniMagick::Image.open("https://s3-eu-west-1.amazonaws.com/idorabucket/uploads/identity/picture/development/80300a88-982a-44ac-99e1-fcfc5d30d7ca/3f42f996-c318-4464-aa81-bfcd0326f8e0.JPG")
   #imageFile = MiniMagick::Image.open("https://s3-eu-west-1.amazonaws.com/idorabucket/uploads/identity/picture/development/80300a88-982a-44ac-99e1-fcfc5d30d7ca/temp/19857c6ab-c30d-4158-a30a-d554cf3a4544.jpeg")
   source_picture = sourcefilename.split("/").last
   #source_key = sourcefilename
   #target_key = "uploads/identity/picture/" +  Rails.env + "/" + @user.unique_id.to_s + "/" + source_picture.to_s
   #s3.copy_object({bucket: bucketname, copy_source: bucketname + '/' + source_key, key: target_key})
   #puts "source_key" + source_key
   puts "source_picture" + source_picture
   puts "@image.picture" + @image.picture.to_s
    #source_picture= "https://s3-eu-west-1.amazonaws.com/" + bucketname + "/" + sourcefilename
   #source_picture= "https://idorabucket.s3.amazonaws.com/" + sourcefilename
   #target_picture= "https://idorabucket.s3.amazonaws.com/" + target_key
   target_picture= source_picture
   puts "target_picture" + target_picture
   #Identity.create(user_id: current_user.id, name: "Unknown", picture: @image.picture)
   #Identity.create(user_id: current_user.id, name: "Unknown", picture: sourcefilename)
   testfile = File.open("/tmp/1_85af3eb6-a27d-4f9e-baaa-7f0eac3d5468.jpeg")
   Identity.create(user_id: current_user.id, name: "testfile", picture:  testfile)
   collectionid=@user.collectionid
   search_faces_by_image(collectionid,bucketname,sourcefilename)

end
def multiple_create_identity_from_image(collectionname,bucketname,sourcefilename,localImage)
  puts "########################################################################"
  puts "create_identity_from_image(collectionname,bucketname,sourcefilename)"
  puts "[" + collectionname + "]"
  puts "[" + bucketname + "]"
  puts "[" + sourcefilename + "]"
  puts "########################################################################"

   s3 = Aws::S3::Client.new(region: 'eu-west-1')

   source_picture = sourcefilename.split("/").last
   puts "source_picture" + source_picture
   puts "@image.picture" + @image.picture.to_s
   target_picture= source_picture
   puts "target_picture" + target_picture
   Identity.create(user_id: current_user.id, name: "testfile", picture:  localImage)
   collectionid=@user.collectionid
   #search_faces_by_image(collectionid,bucketname,sourcefilename)

end

def multiple_faces(collectionid,bucketname,imagefile,resp)
  puts "########################################################################"
  puts "multiple_faces(collectionname,bucketname,sourcefilename)"
  puts "[" + collectionid + "]"
  puts "[" + bucketname + "]"
  puts "[" + imagefile+ "]"
  puts "########################################################################"


  s3 = Aws::S3::Resource.new(region:'eu-west-1')

  collectionid=@user.collectionid
  source_picture = @image.picture.path.split("/").last
  originalImage = MiniMagick::Image.open("https://s3-eu-west-1.amazonaws.com/" + bucketname + "/" + imagefile)
  puts "Image width [" + originalImage.width.to_s + "]"
  puts "Image height [" + originalImage.height.to_s + "]"

  imagewidth= originalImage.width
  imageheight= originalImage.height

  face_number = 0
  resp.face_details.each do |face|
    #localImage=MiniMagick::Image.open("https://s3-eu-west-1.amazonaws.com/" + bucketname + "/" + imagefile,ext="jpg")
    localImage=MiniMagick::Image.open("https://s3-eu-west-1.amazonaws.com/" + bucketname + "/" + imagefile)
    localImage.format('jpg')
    puts "localImage.path [" + localImage.path + "]"
    face_number = face_number + 1
    left = imagewidth *  face.bounding_box.left - (0.1 * imagewidth *  face.bounding_box.width)
    top = imageheight * face.bounding_box.top - (0.1 * imageheight *  face.bounding_box.height)
    width = imagewidth * face.bounding_box.width * 1.2
    height = imageheight * face.bounding_box.height * 1.2
    #
    puts "Heigth [" + height.to_s + "]"
    puts "Width [" + width.to_s + "]"
    puts "Left [" + left.to_s + "]"
    puts "Top [" + top.to_s + "]"

    cropdimensions = width.to_i.to_s + "x" + height.to_i.to_s + "+" + left.to_i.to_s + "+" + top.to_i.to_s
    resizedimensions = (2*width).to_i.to_s + "x" + (2*height).to_i.to_s 
    puts "resizedimensions [" + resizedimensions  + "]"
    puts "cropdimensions [" + cropdimensions  + "]"
    localImage.crop cropdimensions
    localImage.resize('612x612')
    faceCropImageFilename = "/tmp/"+ face_number.to_s + "_"  + source_picture  
    puts "faceCropImageFilename [" + faceCropImageFilename + "]"
    localImage.write(faceCropImageFilename)
    source_picture = @image.picture.path.split("/").last
    sourcefilename= "uploads/identity/picture/" +  Rails.env + "/" + @user.unique_id.to_s + "/temp/" + face_number.to_s + ""  + source_picture.to_s
   
    puts "sourcefilename[" + sourcefilename + "]"
    obj = s3.bucket(bucketname).object(sourcefilename)
    obj.upload_file(faceCropImageFilename )
    #FileUtils.rm(newImageFilename)
    #FileUtils.rm(newImage.path )

    puts "########"
    puts "collectionid" + collectionid.to_s
    puts "bucketname" + bucketname
    puts "sourcefilename" + sourcefilename
    puts "########"
    #search_faces_by_image(collectionid,bucketname,sourcefilename)
    multiple_search_faces_by_image(collectionid,bucketname,sourcefilename,localImage)

  end
end

def search_faces_by_image(collectionname,bucketname,sourcefilename)
  client = Aws::Rekognition::Client.new

  puts "########################################################################"
  puts "search_faces_by_image(collectionname,bucketname,sourcefilename)"
  puts "[" + collectionname + "]"
  puts "[" + bucketname + "]"
  puts "[" + sourcefilename + "]"
  puts "########################################################################"
  
  resp = client.search_faces_by_image({
    collection_id: collectionname,
    face_match_threshold: 60,
    image: {
      s3_object: {
          bucket: bucketname,
          name: sourcefilename,
      },
    },
    max_faces:10
    })

#   rescue Aws::Rekognition::Errors::ServiceError

    if resp.face_matches.count > 0
      resp.face_matches.each do |face_matches|
        puts "Image face matched. Creating match record"
        create_face_match_record(face_matches.face.face_id,resp)
      end
    else
       puts "No image face matched. Creating new identity"
       puts "sourcefilename" + sourcefilename
       create_identity_from_image(collectionname,bucketname,sourcefilename)
    end
  
end

def multiple_search_faces_by_image(collectionname,bucketname,sourcefilename,localImage)
  client = Aws::Rekognition::Client.new

  puts "########################################################################"
  puts "search_faces_by_image(collectionname,bucketname,sourcefilename)"
  puts "[" + collectionname + "]"
  puts "[" + bucketname + "]"
  puts "[" + sourcefilename + "]"
  puts "########################################################################"
  
  resp = client.search_faces_by_image({
    collection_id: collectionname,
    face_match_threshold: 60,
    image: {
      s3_object: {
          bucket: bucketname,
          name: sourcefilename,
      },
    },
    max_faces:10
    })

#   rescue Aws::Rekognition::Errors::ServiceError

    if resp.face_matches.count > 0
      resp.face_matches.each do |face_matches|
        puts "Image face matched. Creating match record"
        create_face_match_record(face_matches.face.face_id,resp)
      end
    else
       puts "No image face matched. Creating new identity"
       puts "sourcefilename" + sourcefilename
       #create_identity_from_image(collectionname,bucketname,sourcefilename)
       multiple_create_identity_from_image(collectionname,bucketname,sourcefilename,localImage)
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
      #
      #  On press of Match button
      #  Get image and user info
      #  Try to match against faces and labels
      #
      #
      bucketname="idorabucket"
      client = Aws::Rekognition::Client.new
      puts "####### On press of Match button"
      @image = Image.find(params[:id])
      @user = User.find(@image.user_id)
      collectionid=@user.collectionid
      puts " collectionid" + collectionid
      picture = @image.picture.path.split("/").last
      imagefile="uploads/image/picture/" +  Rails.env + "/" + @user.unique_id.to_s + "/" + picture.to_s
      puts imagefile

      resp_detect_faces = client.detect_faces({
        image: {
          s3_object: {
              bucket: bucketname,
              name: imagefile,
          },
       },
       })
      puts "Number of faces [" + resp_detect_faces.face_details.count.to_s + "]"

      if resp_detect_faces.face_details.count < 1
        puts "No faces in image"
      elsif resp_detect_faces.face_details.count > 1
        puts "Multiple faces in image"
        multiple_faces(collectionid,bucketname,imagefile,resp_detect_faces)
      else
        puts "Single face in image"
  #      search_faces_by_image(collectionid,bucketname,imagefile)
   #     detect_labels(collectionid,bucketname,imagefile)
      end if

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
