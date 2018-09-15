require 'test_helper'

class UserTest < ActiveSupport::TestCase
   test "the truth" do
     assert true
   end

  def setup
     @user = User.new(email: "adamme@mail.com")
  end

  test "User should be valid" do
 
  assert_not @user.valid?

  end
end
