class ImagesController < ApplicationController
  require 'mini_magick'
  require 'aws-sdk'
  require 'fileutils'
  before_action :set_image, only: [:check, :show, :edit, :update, :destroy]

def detect_labels(collectionname,bucketname,sourcefilename)
client = Aws::Rekognition::Client.new

begin
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
  #rescue  Aws::Rekognition::Errors::InvalidParameterException => e
  rescue Aws::Rekognition::Errors::ServiceError => e
    puts "error rescued"
    puts "Exception Class: #{ e.class.name }"
    puts "Exception Message: #{ e.message }"
    #puts "Exception Backtrace: #{ e.backtrace }"
  end
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
def multiple_create_face_match_record(matchedfaceid,match_response)
 
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

   imageFile = MiniMagick::Image.open("https://s3-eu-west-1.amazonaws.com/" + bucketname + "/" + sourcefilename)
   Identity.create(user_id: current_user.id, name: "Unknown Person", picture:  imageFile)
   search_faces_by_image(collectionname,bucketname,sourcefilename)

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
   Identity.create(user_id: current_user.id, name: "Unknown", picture:  localImage)
   collectionid=@user.collectionid
   picture = @image.picture.path.split("/").last
   imagefile="uploads/image/picture/" +  Rails.env + "/" + @user.unique_id.to_s + "/" + picture.to_s
   search_faces_by_image(collectionid,bucketname,imagefile)

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

  imagewidth= originalImage.width
  imageheight= originalImage.height

  face_number = 0
  resp.face_details.each do |face|
    face_number = face_number + 1
    #
    ## Open orginal image file to create local copy for manipulation
    #
    localImage=MiniMagick::Image.open("https://s3-eu-west-1.amazonaws.com/" + bucketname + "/" + imagefile)
    localImage.format('jpg')
    #
    ## Calculate dimensions for bounding box
    #


    #left = imagewidth * face.bounding_box.left - (0.1 * imagewidth *  face.bounding_box.left)
    #top = imageheight * face.bounding_box.top - (0.1 * imageheight *  face.bounding_box.height)
    #width = imagewidth * face.bounding_box.width * 1.2
    #height = imageheight * face.bounding_box.height * 1.2

    #left = face.bounding_box.left.to_s
    #top = face.bounding_box.top.to_s
    #width = face.bounding_box.width.to_s
    #height = face.bounding_box.height.to_s
    #
    left = imagewidth*face.bounding_box.left - (0.3 * imagewidth *face.bounding_box.width)
    top = imageheight*face.bounding_box.top - (0.3 * imageheight *face.bounding_box.height)
    width = imagewidth*face.bounding_box.width * 1.6
    height = imageheight*face.bounding_box.height * 1.6

    puts "left  [" + left.to_s  + "]"
    puts "top  [" + top.to_s  + "]"
    puts "width  [" + width.to_s  + "]"
    puts "height  [" + height.to_s  + "]"

    cropdimensions = width.to_i.to_s + "x" + height.to_i.to_s + "+" + left.to_i.to_s + "+" + top.to_i.to_s
    puts "cropdimensions [" +  cropdimensions + "]"

    #
    ## Make box bigger to include more face and crop image
    #
    resizedimensions = (2*width).to_i.to_s + "x" + (2*height).to_i.to_s 
    localImage.auto_orient
    localImage.crop cropdimensions
    localImage.resize('612x612')
    #faceCropImageFilename = "/tmp/"+ face_number.to_s + "_"  + source_picture  
    faceCropImageFilename = Rails.root.join("tmp", face_number.to_s + "_" + source_picture  )
    # File.open( File.join(Rails.root, "/app/assets/images/seed/#{file_name}.jpg"))
    localImage.write(faceCropImageFilename)
    #localImage.write(File.join(Rails.root,faceCropImageFilename))
    # 
    ## Generate s3 temp file for recognition before creating identity
    # 
    source_picture = @image.picture.path.split("/").last
    sourcefilename= "uploads/identity/picture/" +  Rails.env + "/" + @user.unique_id.to_s + "/temp/" + face_number.to_s + ""  + source_picture.to_s
   
    puts "upload sourcefilename to s3 temp[" + sourcefilename + "]"
    obj = s3.bucket(bucketname).object(sourcefilename)
    obj.upload_file(faceCropImageFilename )

    #search_faces_by_image(collectionid,bucketname,sourcefilename)
    multiple_search_faces_by_image(collectionid,bucketname,sourcefilename,localImage)
    # Delete temp file from s3
    puts "delete sourcefilename from s3 temp[" + sourcefilename + "]"
    obj.delete

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
  begin 
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
  #rescue  Aws::Rekognition::Errors::InvalidParameterException => e
  rescue Aws::Rekognition::Errors::ServiceError => e
    puts "error rescued"
    puts "Exception Class: #{ e.class.name }"
    puts "Exception Message: #{ e.message }"
    #puts "Exception Backtrace: #{ e.backtrace }"
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
  
  begin 
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
  #rescue  Aws::Rekognition::Errors::InvalidParameterException => e
  rescue Aws::Rekognition::Errors::ServiceError => e
    puts "error rescued"
    puts "Exception Class: #{ e.class.name }"
    puts "Exception Message: #{ e.message }"
    #puts "Exception Backtrace: #{ e.backtrace }"
   end 
end

  #
    # GET /images
    # GET /images.json
  
def index
  @images = Image.where(user_id: current_user.id).paginate(page: params[:page], per_page: 5)
  puts "##### image index #####"
  puts "##### image index #####"
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
      clientrek = Aws::Rekognition::Client.new
      puts "####### On press of Match button"
      @image = Image.find(params[:id])
      @user = User.find(@image.user_id)
      collectionid=@user.collectionid
      puts " collectionid" + collectionid
      picture = @image.picture.path.split("/").last
      imagefile="uploads/image/picture/" +  Rails.env + "/" + @user.unique_id.to_s + "/" + picture.to_s
      puts imagefile

      resp_detect_faces = clientrek.detect_faces({
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
        detect_labels(collectionid,bucketname,imagefile)
      elsif resp_detect_faces.face_details.count > 1
        puts "Multiple faces in image"
        multiple_faces(collectionid,bucketname,imagefile,resp_detect_faces)
        detect_labels(collectionid,bucketname,imagefile)
      else
        puts "Single face in image"
        search_faces_by_image(collectionid,bucketname,imagefile)
        detect_labels(collectionid,bucketname,imagefile)
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
