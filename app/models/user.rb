require 'digest'

class User < ActiveRecord::Base
  
  # attr_accessible is important for preventing a mass assignment vulnerability, a distressingly common and often serious security hole in many Rails applications.
  # Since we�ll be accepting passwords and password confirmations as part of the signup process we need to add the password and 
  # its confirmation to the list of accessible attributes 
  attr_accessible :name, :email, :password, :password_confirmation
  # !!! Explicitly defining accessible attributes is crucial for good site security.
  # For example exclding :admin from the list is the very good idea. If we follishly
  # added :admin to the listm then malicious user can send a PUT request as follows
  # put /users/17?admin=1 This request would make user 17 an admin, which 
  # could be a potentially serious security breach, to say the least.
  
  # has_many :microposts - commented out to accomodate new realtionship
  # association for following postst in the microblog
  has_many :microposts, :dependent => :destroy
  has_many :relationships, :foreign_key => "follower_id",
                           :dependent => :destroy
  has_many :following, :through => :relationships, :source => :followed
  # :source parameter (Listing 12.11), which explicitly tells Rails that the 
  # source of the following array is the set of followed ids
  # Since destroying a user should also destroy that user’s relationships, 
  # we’ve gone ahead and added :dependent => :destroy to the association
  
    
  has_many :microposts, :dependent => :destroy
  # Ensuring that a user’s microposts are destroyed along with the user. 
  
  # Implementing user.followers using reverse relationships.
  
  has_many :reverse_relationships, :foreign_key => "followed_id",
                                   :class_name => "Relationship",
                                   :dependent => :destroy
  has_many :followers, :through => :reverse_relationships, :source => :follower
  
  
  attr_accessor :password
  # We use "attr_accessor :password" to create a virtual password attribute
  # I had to add :salt to attr_accessor because I was getting an error
  # undefined local variable or method `salt' for #<User:0x44f9fe8>
  
  
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :name, :presence => true,
   		   :length   => { :maximum => 50 }
   		   
  validates :email, :presence => true,
   		    :format   => { :with => email_regex },
   		    :uniqueness => { :case_sensitive => false }
   		    
  # Special validation "validates :password, :confirmation => true" will automatically create a virtual attribute 
  # called password_confirmation, while confirming that it matches the password attribute at the same time.
  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..15 }
                       
  before_save :encrypt_password
  
################# AUTHENTICATE SECTION ##################################
  
  # Return true if stored user's password matches the submitted password
  # The has_password? method will test whether a user has the same password as one submitted on a sign-in form  
  def has_password?(submitted_password)
   encrypted_password == encrypt(submitted_password) # this line compares encrypted_password with the encrypted version of
    # submitted_password.  To verify that a submitted password matches the user�s password, we first encrypt the submitted string and 
    # then compare the hashes.
  end
  
  
  # It handles two cases (invalid email and a successful match) with explicit return keywords, 
  # and handles the third case (password mismatch) implicitly, since in that case we reach the 
  # end of the method, which automatically returns nil.
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    puts user.inspect
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end
  
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end
  # Here authenticate_with_salt first finds the user by unique id, and then verifies that the salt stored in the cookie 
  # is the correct one for that user.
  
################# OTHER METHODS ##################################
  	  		  
def feed
    # This is preliminary. See Chapter 12 for the full implementation.
    Micropost.where("user_id = ?", id)
    # The question mark in the line above ensures that id is properly escaped 
    # before being included in the underlying SQL query, thereby avoiding a 
    # serious security hole called SQL injection.
    # he id attribute here is just an integer, so there is no danger in this 
    # case, but always escaping variables injected into SQL statements is a 
    # good habit to cultivate.
  end

def following?(followed)
    relationships.find_by_followed_id(followed)
  end

def follow!(followed)
    relationships.create!(:followed_id => followed.id)
  end

# Unfollowing a user by destroying a user relationship

def following?(followed)
    relationships.find_by_followed_id(followed)
  end

def follow!(followed)
    relationships.create!(:followed_id => followed.id)
  end

def unfollow!(followed)
    relationships.find_by_followed_id(followed).destroy
  end


################# PRIVATE SECTION #####################

private

# All methods defined after private are used internally by the object and are not intended for public use
# In the present context, making the encrypt_password and encrypt methods private isn�t strictly necessary, but it�s a good practice 
# to make them private unless they are needed for the public interface

    def encrypt_password 
      self.salt = make_salt if new_record? # book has unless has_password?(password) instead of if new_record?
      self.encrypted_password = encrypt(password) 
    end
    # Here the encrypt_password callback delegates the actual encryption to an encrypt method
    # This method contains two subtleties: 
    # First***    The left-hand side of the statement explicitly assigns the encrypted_password attribute using the self keyword. 
    #             The class self refers to the object itself, which for the User model is just the user.
    #             The use of self is required in this context; if we omitted - Ruby would create a local variable called 
    #             encrypted_password, which isn�t what we want at all.
    # Second***   Inside the User class, the user object is just self, and we could write 
    #             self.encrypted_password = encrypt(self.password)
    #             But the self is optional here, so for brevity we can write simply self.encrypted_password = encrypt(password)
    

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end
    
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end	
   		    
end
