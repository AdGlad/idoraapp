class PictureUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
   include CarrierWave::MiniMagick

  #process resize_to_limit: [500, 500]
  #process resize_to_limit: [300, 300]

  # Choose what kind of storage to use for this uploader:
  #storage :file
  # storage :fog
  #configure do |config|
  #  config.fog_credentials = {
  #  :provider => 'AWS',
  #  :region                => ENV['S3_REGION'],
  #  :aws_access_key_id => ENV['S3_ACCESS_KEY'],
  #  :aws_secret_access_key => ENV['S3_SECRET_KEY']
  #  }
  #  config.fog_directory = ENV['S3_BUCKET']
  #end
  #if Rails.env.production?
   # storage :fog
  #else
   # storage :file
    storage :fog
  #end

  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  protected
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end

  #def filename
    #@name ||= "#{timestamp}-#{super}" if original_filename.present? and super.present?
    ##@name ||= "#{model.id}-#{super}" if original_filename.present? and super.present?
  #end


#  def timestamp
#    var = :"@#{mounted_as}_timestamp"
#    model.instance_variable_get(var) or model.instance_variable_set(var, Time.now.to_i)
#  end

  #def filename 
  #end

  #def timestamp
  #  var = :"@#{mounted_as}_timestamp"
  #  model.instance_variable_get(var) or model.instance_variable_set(var, Time.now.to_i)
  #end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
   user=User.find(model.user_id)
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{Rails.env}/#{user.unique_id}"
  end
  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
   def extension_whitelist
     %w(jpg jpeg gif png)
   end

  # def filename
   #"#{model.user_id}.#{original_filename}".strip
  # "#{model.id}.#{original_filename}".strip
   #"#{SecureRandom.uuid}#{original_filename}".strip
   #"#{SecureRandom.uuid}.#{file.extension}" 
   #"#{"me"}.#{original_filename}".strip
  # end
  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end


  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
end
