require 'spec_helper'

describe User do
	
	# 1.
	# before(:each) block - all it does is run the code inside the block 
	# before each example�in this case setting the @attr instance variable 
	# to an initialization hash.
	# 2.
	# To write tests for passwords, we�ll need to add two new attributes to the @attr hash, password and password_confirmation.
	# Actually it works like this: we will not introduce a password_confirmation attribute, not even a virtual one. 
	# Instead, we will use the special validation "validates :password, :confirmation => true", which 
	# will automatically create a virtual attribute called password_confirmation, while confirming that it matches the password 
	# attribute at the same time.
	# 3.
	# WHAT WE DO IN THIS block - is basically collect the list of valid attritubes in @ATTR
        
	before(:each) do
		@attr = {
		  :name => "Example user", 
		  :email => "user@example.com",
		  :password => "foobar",
		  :password_confirmation => "foobar"
		}
	  end
			
			# The first example is just a sanity check, verifying that the User model is basically working. 
			# It uses User.create! (read �create bang�), which works just like the create method  
			# except that it raises an ActiveRecord::RecordInvalid exception if the creation fails
			# As long as the attributes are valid, it won�t raise any exceptions, and the test will pass.
			
			it "Should create a new instance given valid attribues" do
			User.create!(@attr)
			end
			
			# The final line is the test for the presence of the name attribute�or rather, it would be the actual test, 
			# if it had anything in it. Instead, the test is just a stub, but a useful stub it is: it�s a pending spec, 
			# which is a way to write a description of the application�s behavior without worrying yet about the implementation.
			# Pending specs are useful as placeholders for tests we know we need to write at some point but don�t want to deal 
			# with right now.
			# IT IS COMMENTED OUT BECAUSE WE ARE GONNA CREATE THE PASSING EXAMPLE NOW
			# it "Should require a name"
			
			
			
			################## USER NAME PRESENCE TESTS #######################
			
			it "should require a name" do
				no_name_user = User.new(@attr.merge(:name => ""))
				no_name_user.should_not be_valid
 			end
 			# Here we use merge to make a new user called no_name_user with a blank name. 
 			# The second line then uses the RSpec should_not method to verify that the resulting user is not valid. 
 			
 			################## USERNAME LENGTH TESTS #######################
 			
 			it "should reject names that are too long" do
 				long_name = "a" * 21
 				long_name_user = User.new(@attr.merge(:name => long_name))
 				long_name_user.should_not be_valid
 			end
 			
 			################## EMAIL VALID FORMAT TESTS #######################
 			
 			it "should accept valid email addresses" do
 				addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
 				addresses.each do |address|
 				valid_email_user = User.new(@attr.merge(:email => address))
 				valid_email_user.should be_valid
 			end
 			end
 			
 			################## TESTS FOR INVALID EMAIL FORMAT #######################
 			
 			it "should reject invalid email addresses" do
 				addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
 				addresses.each do |address|
 				invalid_email_user = User.new(@attr.merge(:email => address))
 				invalid_email_user.should_not be_valid
 			end
 			end

 			################## UNIQUENESS TESTS #######################
 			
 			it "should reject duplicate email addresses" do
 				# Put a user with given email address into the database.
 				User.create!(@attr)
 				user_with_duplicate_email = User.new(@attr)
 				user_with_duplicate_email.should_not be_valid
 			end
 			# The method here is to create a user and then try to make another one with the same email address. 
 			# (We use the noisy method create! so that it will raise an exception if anything goes wrong. 
 			# Using create, without the bang !, risks having a silent error in our test, a potential source of elusive bugs.)
 			
 			
 			################## CASE SENSITIVITY TESTS #######################
 			
 			it "should reject email addresses identical up to case" do
 				upcased_email = @attr[:email].upcase
 				User.create!(@attr.merge(:email => upcased_email))
 				user_with_duplicate_email = User.new(@attr)
 				user_with_duplicate_email.should_not be_valid
 			end
 			
 			################## PASSWORD TESTS #######################
 			
 			# TESTS FOR:
 			# --- presence of the password and its confirmation
 			# tests confirming that the password is a valid length (restricted somewhat arbitrarily 
 			# to be between 6 and 40 characters long).
 			
 			describe "password validations" do
 			
 			################## BLANK PASSWORD IS NOT ACCEPTED #######################
 			
 			it "should require a password" do
			User.new(@attr.merge(:password => "", :password_confirmation => "")).
			should_not be_valid
			end
			
			################## PASSWORDS SHOULD MATCH #######################
			
			it "should require a matching password confirmation" do
			User.new(@attr.merge(:password_confirmation => "invalid")).
			should_not be_valid
			end
			
			################## PASSWORD SHOULD BE AT LEAST 6 CHATACTERS #######################
			
			it "should reject short passwords" do
			short = "a" * 5
			hash = @attr.merge(:password => short, :password_confirmation => short)
			User.new(hash).should_not be_valid
			end
			
			################## PASSWORD SHOULD NOT EXCEED 16 CHARACTERS #######################
			
			it "should reject long passwords" do
			long = "a" * 16
			hash = @attr.merge(:password => long, :password_confirmation => long)
			User.new(hash).should_not be_valid
			end
			
			
			
			
			################## PASSWORD ENCRYPTION TESTS #######################
			
			describe "password encryption" do
				
				before(:each) do
				@user = User.create!(@attr) # we are going to need a valid user in order for these tests to run.
				end
				
			################## PASSWORD SHOULD HAVE ENCRYPTED ATTRIBUTE #######################
				
			it "should have an encrypted password attribute" do
			@user.should respond_to(:encrypted_password)
			end
			
			################## PASSWORD SHOULD BE ENCRYPTED #######################
			
			it "should set the encrypted password" do
			@user.encrypted_password.should_not be_blank
			end
			# This code verifies that encrypted_password.blank? is not true using the construction should_not be_blank.
			# To get this test to pass, we register a callback called encrypt_password by passing a symbol of that name 
			# to the before_save method, and then define an encrypt_password method to perform the encryption. 
			# With the before_save in place, Active Record will automatically call the corresponding method before saving 
			# the record. 
			
			
			################## PASSWORDS SUBMITED AND STORED SHOULD MATCH #######################
			
			describe "has_password? method" do

		        it "should be true if the passwords match" do
			@user.has_password?(@attr[:password]).should be_true
		        end    
		  
		        it "should be false if the passwords don't match" do
			@user.has_password?("invalid").should be_false
		        end 
		        end
		        
		        
		        
		        ################## TESTS FOR AUTHENTICATION #######################
		        
		        describe "authenticate method" do
 
		        it "should return nil on email/password mismatch" do
			wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
			wrong_password_user.should be_nil
		        end
		
		        it "should return nil for an email address with no user" do
			nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
			nonexistent_user.should be_nil
		        end
		
		        it "should return the user on email/password match" do
			matching_user = User.authenticate(@attr[:email], @attr[:password])
			matching_user.should == @user
		        end
		        end
		    
			################## TESTING THE ORDER OF USER'S MICROPOSTS #############
			
			describe "micropost associations" do

    before(:each) do
      @user = User.create(@attr)
      @mp1 = Factory(:micropost, :user => @user, :created_at => 1.day.ago)
      @mp2 = Factory(:micropost, :user => @user, :created_at => 1.hour.ago)
    end

    it "should have a microposts attribute" do
      @user.should respond_to(:microposts)
    end

    it "should have the right microposts in the right order" do
      @user.microposts.should == [@mp2, @mp1]
      # indicating that the posts should be ordered newest first. 
      # to get the ordering test to pass  we use a Rails facility called default_scope
      # with an :order parameter - located in app/models/micropost.rb  - default_scope :order => 'microposts.created_at DESC'
    end
  end
  
################## TESTING THAT MICROPOSTS ARE DESROYED WHEN USERS ARE #############
  
  describe "micropost associations" do

      it "should destroy associated microposts" do
      @user.destroy
      [@mp1, @mp2].each do |micropost|
        Micropost.find_by_id(micropost.id).should be_nil
      end
    end
   end

   
################## TEST FOR THE (PROTO)STATUS FEED  #############
 
     describe "status feed" do

      it "should have a feed" do
        @user.should respond_to(:feed)
      end

      it "should include the user's microposts" do
        @user.feed.include?(@mp1).should be_true
        @user.feed.include?(@mp2).should be_true
      end
      # include? method simply checks if an array includes the given element
      # $ rails console
      # >> a = [1, "foo", :bar]
      # >> a.include?("foo")
      # => true
      # >> a.include?(:bar)
      # => true
      # >> a.include?("baz")
      # => false

      it "should not include a different user's microposts" do
        mp3 = Factory(:micropost,
                      :user => Factory(:user, :email => Factory.next(:email)))
        @user.feed.include?(mp3).should be_false
      end
    
    end

################## TEST FOR USER.RELATIONSHIPS ATTRIBUTE  ###################
 
 
describe "relationships" do

    before(:each) do
      @user = User.create!(@attr)
      @followed = Factory(:user)
    end

    it "should have a relationships method" do
      @user.should respond_to(:relationships)
    end
  end
  
#################### TEST FOR USER.FOLLOWING ATTRIBUTE ##################

describe "relationships" do

    before(:each) do
      @user = User.create!(@attr)
      @followed = Factory(:user)
    end

    it "should have a relationships method" do
      @user.should respond_to(:relationships)
    end

    it "should have a following method" do
      @user.should respond_to(:following)
    end
    
    ###### Tests for some “following” utility methods. #####
    
    it "should have a following? method" do
      @user.should respond_to(:following?)
    end
    
    it "should have a follow! method" do
      @user.should respond_to(:follow!)
    end

    it "should follow another user" do
      @user.follow!(@followed)
      @user.should be_following(@followed)
    end

    it "should include the followed user in the following array" do
      @user.follow!(@followed)
      @user.following.should include(@followed)
    end
    
    ####### A test for unfollowing a user. ##########
    
    it "should have an unfollow! method" do
      @followed.should respond_to(:unfollow!)
    end

    it "should unfollow a user" do
      @user.follow!(@followed)
      @user.unfollow!(@followed)
      @user.should_not be_following(@followed)
    end
    
    # Testing for reverse relationships.
    
      it "should have a reverse_relationships method" do
      @user.should respond_to(:reverse_relationships)
    end
    
    it "should have a followers method" do
      @user.should respond_to(:followers)
    end

    it "should include the follower in the followers array" do
      @user.follow!(@followed)
      @followed.followers.should include(@user)
    end
    
  end
 
############################# EL FONDO  #####################################
			
		end	
	end
end
						
