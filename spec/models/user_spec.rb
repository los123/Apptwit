require 'spec_helper'

describe User do
	
	# before(:each) block - all it does is run the code inside the block 
	# before each example�in this case setting the @attr instance variable 
	# to an initialization hash.
	before(:each) do
		@attr = {:name => "Example user", :email => "user@example.com"}
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
			
			# NAME PRESENCE TEST
			it "should require a name" do
				no_name_user = User.new(@attr.merge(:name => ""))
				no_name_user.should_not be_valid
 			end
 			# Here we use merge to make a new user called no_name_user with a blank name. 
 			# The second line then uses the RSpec should_not method to verify that the resulting user is not valid. 
 			
 			#LENGHT TEST
 			it "should reject names that are too long" do
 				long_name = "a" * 21
 				long_name_user = User.new(@attr.merge(:name => long_name))
 				long_name_user.should_not be_valid
 			end
 			
 			# VALID FORMAT TEST
 			it "should accept valid email addresses" do
 				addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
 				addresses.each do |address|
 				valid_email_user = User.new(@attr.merge(:email => address))
 				valid_email_user.should be_valid
 			end
 			end
 			
 			# INVALID FORMAT TEST
 			it "should reject invalid email addresses" do
 				addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
 				addresses.each do |address|
 				invalid_email_user = User.new(@attr.merge(:email => address))
 				invalid_email_user.should_not be_valid
 			end
 			end

 			# UNIQUENESS TEST
 			it "should reject duplicate email addresses" do
 				# Put a user with given email address into the database.
 				User.create!(@attr)
 				user_with_duplicate_email = User.new(@attr)
 				user_with_duplicate_email.should_not be_valid
 			end
 			# The method here is to create a user and then try to make another one with the same email address. 
 			# (We use the noisy method create! so that it will raise an exception if anything goes wrong. 
 			# Using create, without the bang !, risks having a silent error in our test, a potential source of elusive bugs.)
 			
 			# CASE-INSENSITIVE TEST
 			it "should reject email addresses identical up to case" do
 				upcased_email = @attr[:email].upcase
 				User.create!(@attr.merge(:email => upcased_email))
 				user_with_duplicate_email = User.new(@attr)
 				user_with_duplicate_email.should_not be_valid
 			end
 			
end
				
