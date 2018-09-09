class IdentityUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick
  process resize_to_limit: [300, 300]

#  # Choose what kind of storage to use for this uploader:
# #CarrierWave.configure do |config|
#
#  #if Rails.env.development? || Rails.env.test?
#  #  config.storage = :file
#  #else
#    #config.fog_provider = 'fog/aws'
#    #config.fog_credentials = {
#      #provider: 'AWS',
#      #aws_access_key_id: ENV['S3_ACCESS_KEY_ID'],
#      #aws_secret_access_key: ENV['S3_SECRET_ACCESS_KEY'],
#      #region: ENV['S3_REGION'],
#      #endpoint: 'https://s3.amazonaws.com'
#    #}
#    #config.fog_directory = ENV['S3_BUCKET']
#    #config.fog_public = false
#    #config.storage = :fog
#  #end
##end
#  fog_credentials = {
#      provider: 'AWS',
#      aws_access_key_id: ENV['S3_ACCESS_KEY_ID'],
#      aws_secret_access_key: ENV['S3_SECRET_ACCESS_KEY'],
#      region: ENV['S3_REGION'],
#      endpoint: 'https://s3.amazonaws.com'
#    }
#  fog_directory = ENV['S3_BUCKET']
#  fog_provider = 'fog/aws'
#  storage :fog
#  storage :file
  # configure do |config|
  #  config.fog_credentials = {
  #  :provider => 'AWS',
  #  :region                => ENV['S3_REGION'],
  #  :aws_access_key_id => ENV['S3_ACCESS_KEY'],
  #  :aws_secret_access_key => ENV['S3_SECRET_KEY']
  #  }
  #  config.fog_directory = ENV['S3_BUCKET']
  #end
 # if Rails.env.production?
    storage :fog
  #else
   # storage :file
  #end
#    
  #storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    #"uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.user_id}"
  end

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

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
   def extension_whitelist
     %w(jpg jpeg gif png)
   end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end
end
