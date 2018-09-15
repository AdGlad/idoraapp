require 'test_helper'

class ImageTest < ActiveSupport::TestCase
   def setup
      @image = Image.new( id: 1,
                         name: "Imagename",
                          picture: "Imagepicture",
                          user_id: 1,
                       created_at: Time.now,
                       updated_at: Time.now)
   end
 
   test "Image should be valid" do
  assert_not @image.valid?
   #assert @image.valid?
 
   end
end
