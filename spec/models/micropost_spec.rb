require 'spec_helper'

# First, we want to replicate the Micropost.create! test shown in Listing 11.3 without 
# the invalid mass assignment. 
# Second, we see from Figure 11.2 that a micropost object should have a user method. 
# Finally, micropost.user should be the user corresponding to the micropost’s user_id. We can express these requirements in RSpec with the code in Listing 11.4.


#######   TESTS FOR THE MICROPOST'S USER ASSOCIATION   ############

describe Micropost do

  before(:each) do
    @user = Factory(:user)
    @attr = { :content => "value for content" }
  end
  # We use a factory user because these tests are for the Micropost model, 
  # not the User model

  it "should create a new instance given valid attributes" do
    @user.microposts.create!(@attr)
    # Rather than using Micropost.create or Micropost.create! to create a micropost
    # it uses @user.microposts.create(@attr) (or @user.microposts.create!(@attr)). This
    # patter is the canonical way a micropost through its association with users.
    # When created in this way, the micropost object automatically has its user_id set 
    # to the right value
  end

  describe "user associations" do
    
    before(:each) do
      @micropost = @user.microposts.create(@attr)
    end

    it "should have a user attribute" do
      @micropost.should respond_to(:user)
    end
    
    it "should have the right associated user" do
      @micropost.user_id.should == @user.id
      @micropost.user.should == @user
    end
  end
  
  ############   TEST FOR THE MICROPOST MODEL VALIDATIONS ##############
  
  describe "validations" do

    it "should require a user id" do
      Micropost.new(@attr).should_not be_valid
    end

    it "should require nonblank content" do
      @user.microposts.build(:content => "  ").should_not be_valid
    end

    it "should reject long content" do
      @user.microposts.build(:content => "a" * 141).should_not be_valid
    end
  end
  
# instead of using the default new constructor as in User.new(...)
# the code uses the build method: @user.microposts.build
# Recall from Table 11.1 that this is essentially equivalent to Micropost.new, 
# except that it automatically sets the micropost’s user_id to @user.id.
  
end
