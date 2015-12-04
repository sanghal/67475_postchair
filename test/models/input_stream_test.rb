require 'test_helper'

class InputStreamTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  #validations
#  should belong_to(:user)

#  should allow_value(0).for(:user_id)
#  should_not allow_value("zero").for(:user_id)
  
#  should allow_value(0).for(:set_id)
#  should_not allow_value("zero").for(:set_id)
  
#  should allow_value(1).for(:position)
#  should allow_value(2).for(:position)
#  should allow_value(3).for(:position)
#  should allow_value(4).for(:position)
#  should_not allow_value("zero").for(:user_id)

  #set up context
  context "Creating an InputStream context" do
    setup do
      create_input_streams_sets
    end

    teardown do
      delete_input_streams_sets
    end
    
    should "verify that determine_posture works" do
      assert_equal 'SB', InputStream.determine_posture(@set_sb)
      assert_equal 'CPR', InputStream.determine_posture(@set_cpr)
      assert_equal 'NSB', InputStream.determine_posture(@set_nsb)
      assert_equal 'SS', InputStream.determine_posture(@set_ss)
      assert_equal 'GP', InputStream.determine_posture(@set_gp)
      assert_equal 'NS', InputStream.determine_posture(@set_ns)
      assert_equal 'UK', InputStream.determine_posture(@set_uk)
    end
    
  end
  
  
end
