class IdentitiesController < ApplicationController
  require 'aws-sdk'
  before_action :set_identity, only: [:show, :edit, :update, :destroy]

  # GET /identities
  # GET /identities.json
  def index
    @identities = Identity.where(user_id: current_user.id).paginate(page: params[:page], per_page: 5)
  end

  # GET /identities/1
  # GET /identities/1.json
  def show
     @identity = Identity.find(params[:id])
     @images = @identity.images.where(user_id: current_user.id).paginate(page: params[:page], per_page: 5)
  end

  # GET /identities/new
  def new
    @identity = Identity.new
  end

  # GET /identities/1/edit
  def edit
  end

  # POST /identities
  # POST /identities.json
  def create
    @identity = Identity.new(identity_params)
    @identity.user = current_user

    respond_to do |format|
      if @identity.save
        format.html { redirect_to @identity, notice: 'Identity was successfully created.' }
        format.json { render :show, status: :created, location: @identity }
      else
        format.html { render :new }
        format.json { render json: @identity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /identities/1
  # PATCH/PUT /identities/1.json
  def update
    respond_to do |format|
      if @identity.update(identity_params)
        format.html { redirect_to @identity, notice: 'Identity was successfully updated.' }
        format.json { render :show, status: :ok, location: @identity }
      else
        format.html { render :edit }
        format.json { render json: @identity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /identities/1
  # DELETE /identities/1.json
  def destroy
    identityface_id = @identity.face_id

   if identityface_id.empty?
     puts "No face id found"
   else
     client = Aws::Rekognition::Client.new
     resp = client.delete_faces({
        collection_id: current_user.collectionid,
        face_ids: [@identity.face_id
        ], 
      })
     puts "***** Deleted identity from collection"
     puts resp.to_h
   end if

   @identity.destroy 
    respond_to do |format|
      format.html { redirect_to identities_url, notice: 'Identity was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_identity
      @identity = Identity.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def identity_params
      params.require(:identity).permit(:user_id, :name, :dob, :team, :desc, :picture )
    end
end
